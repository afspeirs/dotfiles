function project() {
  if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    cat <<'EOF'
Create or switch to a project workspace.

Usage:
  project <path> [path...]

Examples:
  project .
  project ~/dotfiles

  project \
    ~/src/project-name/frontend \
    ~/src/project-name/backend

Behaviour for each path:
  - Names the session after the directory (or parent directory for multiple paths).
  - Creates one window/tab per path.
  - Starts nvim in each.
  - For multiple paths, windows/tabs are named after each directory.

Backend:
  - Uses herdr when it is installed and you are not already inside tmux.
  - Falls back to tmux otherwise.
  - Under herdr, a project becomes a labelled workspace in the current
    session rather than a separate session.

Notes:
  - Existing sessions/workspaces are reused and are not modified.
  - Names have '.' replaced with '_'.
  - When run inside a multiplexer, the current client switches to it.
  - When run outside one, it attaches.
EOF
    return 0
  fi

  local first_dir
  local name

  if ! first_dir="$(cd "$1" 2>/dev/null && pwd)"; then
    echo "Not a directory: $1"
    return 1
  fi

  if [[ $# -eq 1 ]]; then
    name="$(basename "$first_dir")"
  else
    name="$(basename "$(dirname "$first_dir")")"
  fi

  name="${name//./_}"

  local multi_repo=false
  [[ $# -gt 1 ]] && multi_repo=true

  # Inside tmux, defer to tmux. Inside herdr, use its API to switch the
  # current client, since herdr blocks nesting unless experimental
  # allow_nested is set. Outside both, attach to herdr (falling back to
  # tmux when herdr is not installed).
  if [[ -n "$TMUX" ]]; then
    _project_tmux "$name" "$multi_repo" "$@"
  elif [[ "$HERDR_ENV" == "1" ]]; then
    _project_herdr "$name" "$multi_repo" "$@"
  elif exists herdr; then
    _project_herdr_attach "$name" "$multi_repo" "$@"
  else
    _project_tmux "$name" "$multi_repo" "$@"
  fi
}

# Switch the current herdr client to a workspace, without attaching.
function _project_herdr() {
  local name="$1"
  local multi_repo="$2"
  shift 2

  _project_herdr_build "$name" "$multi_repo" "$@" || return 1
  herdr workspace focus "$(_project_herdr_lookup "$name")" >/dev/null
}

# Create the workspace, then hand the terminal over to a herdr client.
function _project_herdr_attach() {
  local name="$1"
  local multi_repo="$2"
  shift 2

  _project_herdr_build "$name" "$multi_repo" "$@" || return 1

  # `herdr` with no arguments launches or attaches to the persistent session,
  # which is what we want when there is no client on this terminal yet.
  exec herdr
}

# Create or reuse the workspace for a project, leaving focus alone.
function _project_herdr_build() {
  local name="$1"
  local multi_repo="$2"
  shift 2

  local -a paths=()
  local dir

  for repo_path in "$@"; do
    if ! dir="$(cd "$repo_path" 2>/dev/null && pwd)"; then
      echo "Not a directory: $repo_path"
      return 1
    fi
    paths+=("$dir")
  done

  # Reuse an existing workspace with this label rather than creating a second.
  local existing
  existing=$(_herdr_workspace_id_by_label "$name")

  if [[ -n "$existing" ]]; then
    herdr workspace focus "$existing" >/dev/null
    return 0
  fi


  # The create response carries both ids, which is more reliable than a
  # follow-up lookup: `herdr tab list` omits the focused workspace.
  local response
  response=$(
    herdr workspace create \
      --cwd "${paths[1]}" \
      --label "$name" \
      --no-focus 2>/dev/null
  )

  local workspace_id
  workspace_id=$(print -r -- "$response" | _herdr_field '"workspace_id"' 1)
  local first_pane
  first_pane=$(print -r -- "$response" | _herdr_field '"pane_id"' 1)
  local first_tab
  first_tab=$(print -r -- "$response" | _herdr_field '"tab_id"' 1)

  if [[ -z "$workspace_id" ]]; then
    echo "Failed to create herdr workspace: $name"
    return 1
  fi

  herdr workspace focus "$workspace_id" >/dev/null

  # `workspace create` has no --label for the tab itself, so name it here.
  if [[ "$multi_repo" == true ]] && [[ -n "$first_tab" ]]; then
    local first_label="${paths[1]##*/}"
    herdr tab rename "$first_tab" "${first_label//./_}" >/dev/null 2>&1
  fi

  # The first tab already runs a shell in paths[1]; start nvim there.
  [[ -n "$first_pane" ]] && herdr pane run "$first_pane" nvim >/dev/null 2>&1

  # `herdr tab create` always targets the focused workspace, so the extra
  # paths only land here correctly because the workspace was just focused.
  if [[ "$multi_repo" == true ]]; then
    local i
    for (( i = 2; i <= ${#paths[@]}; i++ )); do
      local tab_label="${paths[$i]##*/}"
      tab_label="${tab_label//./_}"

      local tab_response
      tab_response=$(
        herdr tab create \
          --cwd "${paths[$i]}" \
          --label "$tab_label" \
          --no-focus 2>/dev/null
      )

      local tab_pane
      tab_pane=$(print -r -- "$tab_response" | _herdr_field '"pane_id"' 1)

      if [[ -z "$tab_pane" ]]; then
        echo "Failed to create tab for: ${paths[$i]}"
        return 1
      fi

      herdr pane run "$tab_pane" nvim >/dev/null 2>&1
    done
  fi

  herdr workspace focus "$workspace_id" >/dev/null
  return 0
}

# Print the workspace id for a project label, empty if none exists.
function _project_herdr_lookup() {
  _herdr_workspace_id_by_label "$1"
}

# Print the nth value of a JSON string field from a single-line herdr response.
function _herdr_field() {
  local key="$1"
  local nth="${2:-1}"
  command grep -o "${key}:\"[^\"]*\"" |
    command sed -n "${nth}s/.*:\"\(.*\)\"/\1/p"
}

# Print the workspace id whose label matches exactly, if any.
function _herdr_workspace_id_by_label() {
  local label="$1"
  herdr workspace list 2>/dev/null |
    command tr '{' '\n' |
    command grep -F "\"label\":\"${label}\"," |
    _herdr_field '"workspace_id"' 1
}

function _project_tmux() {
  local session="$1"
  local multi_repo="$2"
  shift 2

  if ! tmux has-session -t "$session" 2>/dev/null; then
    local first_window=true
    local dir
    local window

    for repo_path in "$@"; do

      if ! dir="$(cd "$repo_path" 2>/dev/null && pwd)"; then
        echo "Not a directory: $repo_path"
        return 1
      fi

      if [[ "$multi_repo" == true ]]; then
        window="$(basename "$dir")"
        window="${window//./_}"
      fi

      if $first_window; then
        if [[ "$multi_repo" == true ]]; then
          tmux new-session \
            -d \
            -s "$session" \
            -n "$window" \
            -c "$dir" \
            'nvim'
        else
          tmux new-session \
            -d \
            -s "$session" \
            -c "$dir" \
            'nvim'
        fi

        first_window=false
      else
        if [[ "$multi_repo" == true ]]; then
          tmux new-window \
            -t "$session" \
            -n "$window" \
            -c "$dir" \
            'nvim'
        else
          tmux new-window \
            -t "$session" \
            -c "$dir" \
            'nvim'
        fi
      fi
    done
  fi

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$session"
  else
    tmux attach-session -t "$session"
  fi
}
