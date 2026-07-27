function project() {
  if [[ $# -eq 0 ]] || [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]]; then
    cat <<'EOF'
Create or switch to a tmux session for a project directory.

Usage:
  $ project <path>
  $ project -h

Examples:
  $ project .
  $ project ~/dotfiles

Result:
  Session: <directory-name>

  Windows:
    0: editor   (running nvim)
    1: terminal

Notes:
  - Session names are derived from the directory name.
  - Existing sessions are reused.
  - When run inside tmux, the current client switches to the session.
  - When run outside tmux, it attaches to the session.
EOF
    return 0
  fi

  local dir
  local session

  dir="$(realpath "$1")"

  if [[ ! -d "$dir" ]]; then
    echo "Not a directory: $dir"
    return 1
  fi

  session="$(basename "$dir" | tr '.' '_')"

  if ! tmux has-session -t "$session" 2>/dev/null; then
    tmux new-session -d \
      -s "$session" \
      -c "$dir" \
      -n editor

    tmux send-keys \
      -t "$session":editor \
      'nvim' C-m

    tmux new-window \
      -t "$session" \
      -n shell \
      -c "$dir"
  fi

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$session"
  else
    tmux attach-session -t "$session"
  fi
}
