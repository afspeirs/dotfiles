function project() {
  if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    cat <<'EOF'
Create or switch to a tmux project session.

Usage:
  project <path> [path...]

Examples:
  project .
  project ~/dotfiles

  project \
    ~/src/project-name/frontend \
    ~/src/project-name/backend

Behaviour for each path:
  - Creates a session named after the directory (or parent directory for multiple paths).
  - Creates one window.
  - Starts nvim.
  - For multiple paths, windows are named after each directory.

Notes:
  - Existing sessions are reused and are not modified.
  - Session names have '.' replaced with '_'.
  - When run inside tmux, the current client switches to the session.
  - When run outside tmux, it attaches to the session.
EOF
    return 0
  fi

  local first_dir
  local session

  if ! first_dir="$(cd "$1" 2>/dev/null && pwd)"; then
    echo "Not a directory: $1"
    return 1
  fi

  if [[ $# -eq 1 ]]; then
    session="$(basename "$first_dir")"
  else
    session="$(basename "$(dirname "$first_dir")")"
  fi

  session="${session//./_}"

  local multi_repo=false
  [[ $# -gt 1 ]] && multi_repo=true

  if ! tmux has-session -t "$session" 2>/dev/null; then

    local first_window=true

    for repo_path in "$@"; do
      local dir
      local window

      if ! dir="$(cd "$repo_path" 2>/dev/null && pwd)"; then
        echo "Not a directory: $repo_path"
        return 1
      fi

      if $multi_repo; then
        window="$(basename "$dir")"
        window="${window//./_}"
      fi

      if $first_window; then
        if $multi_repo; then
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
        if $multi_repo; then
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
