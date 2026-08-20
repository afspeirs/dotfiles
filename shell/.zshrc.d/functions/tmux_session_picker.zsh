function tmux_session_picker() {
  local store_dir="${XDG_CONFIG_HOME:-$HOME/.config}/t"
  local store_file="$store_dir/sessions"

  if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    cat <<'EOF'
Attach to a tmux session, create a new one, or launch saved projects.

Usage:
  tmux_session_picker
  tmux_session_picker add <name> <path> [path...]
  tmux_session_picker rm <name>
  tmux_session_picker ls

Options:
  -h    Show this help message

Examples:
  tmux_session_picker
  tmux_session_picker add dotfiles ~/dotfiles
  tmux_session_picker add acme ~/src/acme/frontend ~/src/acme/backend
  tmux_session_picker rm acme
  tmux_session_picker ls

Behaviour:
  - Shows options in fzf.
  - Includes a [new session] option.
  - Includes running tmux sessions and saved entries.
  - [new session] uses `project .`.
  - Saved entries use `project <path> [path...]`.
  - Esc cancels without changing sessions.

Notes:
  - Saved entries are stored in:
      ${XDG_CONFIG_HOME:-$HOME/.config}/t/sessions
  - Saved format is:
      name<TAB>path1<TAB>path2...
EOF
    return 0
  fi

  case "$1" in
    add)
      if [[ $# -lt 3 ]]; then
        echo "Usage: tmux_session_picker add <name> <path> [path...]"
        return 1
      fi

      local name="$2"
      shift 2

      if [[ "$name" == *$'\t'* ]]; then
        echo "Session name cannot contain tabs: $name"
        return 1
      fi

      local -a resolved_paths=()
      local repo_path

      for repo_path in "$@"; do
        local dir
        if ! dir="$(cd "$repo_path" 2>/dev/null && pwd)"; then
          echo "Not a directory: $repo_path"
          return 1
        fi
        resolved_paths+=("$dir")
      done

      if [[ -f "$store_file" ]]; then
        local line
        while IFS= read -r line; do
          [[ -z "$line" ]] && continue
          local -a fields=("${(@ps:\t:)line}")
          [[ "${fields[1]}" == "$name" ]] && {
            echo "Saved entry already exists: $name"
            return 1
          }
        done < "$store_file"
      fi

      mkdir -p "$store_dir" || return 1

      local record="$name"
      for repo_path in "${resolved_paths[@]}"; do
        record+=$'\t'"$repo_path"
      done

      print -r -- "$record" >> "$store_file"
      echo "Saved: $name"
      return 0
      ;;

    rm)
      if [[ $# -ne 2 ]]; then
        echo "Usage: tmux_session_picker rm <name>"
        return 1
      fi

      local name="$2"

      if [[ ! -f "$store_file" ]]; then
        echo "No saved entries found."
        return 1
      fi

      local tmp
      tmp="$(mktemp)" || return 1

      local removed=false
      local line
      while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        local -a fields=("${(@ps:\t:)line}")
        if [[ "${fields[1]}" == "$name" ]]; then
          removed=true
          continue
        fi
        print -r -- "$line" >> "$tmp"
      done < "$store_file"

      if ! $removed; then
        rm -f "$tmp"
        echo "Saved entry not found: $name"
        return 1
      fi

      mv "$tmp" "$store_file"
      echo "Removed: $name"
      return 0
      ;;

    ls)
      if [[ ! -s "$store_file" ]]; then
        echo "No saved entries."
        return 0
      fi

      local line
      while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        local -a fields=("${(@ps:\t:)line}")
        local name="${fields[1]}"
        local -a paths=("${fields[@]:1}")
        echo "$name: ${paths[*]}"
      done < "$store_file"
      return 0
      ;;

    "")
      ;;

    *)
      echo "Unknown option: $1"
      echo "Run 'tmux_session_picker -h' for usage."
      return 1
      ;;
  esac

  local selected

  selected=$(
    {
      local -a tmux_sessions=()
      typeset -A tmux_session_exists
      local session
      while IFS= read -r session; do
        [[ -z "$session" ]] && continue
        tmux_sessions+=("$session")
        tmux_session_exists[$session]=1
      done < <(tmux list-sessions -F "#{session_name}" 2>/dev/null | LC_ALL=C sort)

      printf '%s\n' '[new session]'
      for session in "${tmux_sessions[@]}"; do
        printf '%s\n' "[tmux] $session"
      done

      if [[ -f "$store_file" ]]; then
        local line
        while IFS= read -r line; do
          [[ -z "$line" ]] && continue
          local -a fields=("${(@ps:\t:)line}")
          if [[ -n "${tmux_session_exists[${fields[1]}]}" ]]; then
            continue
          fi
          printf '%s\n' "[saved] ${fields[1]}"
        done < "$store_file"
      fi
    } | FZF_DEFAULT_OPTS='' command fzf --no-sort
  )

  [[ -z "$selected" ]] && return 0

  if [[ "$selected" == "[new session]" ]]; then
    project .
    return
  fi

  if [[ "$selected" == "[tmux] "* ]]; then
    local session_name="${selected#"[tmux] "}"
    if [[ -n "$TMUX" ]]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach-session -t "$session_name"
    fi
    return
  fi

  if [[ "$selected" == "[saved] "* ]]; then
    local saved_name="${selected#"[saved] "}"
    local -a saved_entry_paths=()
    local line
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      local -a fields=("${(@ps:\t:)line}")
      if [[ "${fields[1]}" == "$saved_name" ]]; then
        saved_entry_paths=("${fields[@]:1}")
        break
      fi
    done < "$store_file"

    if [[ ${#saved_entry_paths[@]} -eq 0 ]]; then
      echo "Saved entry not found: $saved_name"
      return 1
    fi

    project "${saved_entry_paths[@]}"
    return
  fi

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$selected"
  else
    tmux attach-session -t "$selected"
  fi
}
