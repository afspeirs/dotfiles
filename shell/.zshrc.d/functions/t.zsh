function t() {
  if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    cat <<'EOF'
Attach to a tmux session or create a new one.

Usage:
  t [options]

Options:
  -h    Show this help message

Examples:
  t

Behaviour:
  - Shows sessions in fzf.
  - Includes a [new session] option.
  - Esc cancels without changing sessions.

Notes:
  - When run inside tmux, the current client switches
    to the selected session.
  - When run outside tmux, it attaches to the selected
    session.
EOF
    return 0
  fi

  local selected
  selected=$(
    {
      printf '%s\n' '[new session]'
      tmux list-sessions -F "#{session_name}" 2>/dev/null | LC_ALL=C sort
    } | FZF_DEFAULT_OPTS='' command fzf --no-sort
  )

  [[ -z "$selected" ]] && return 0

  if [[ "$selected" == "[new session]" ]]; then
    tmux new-session
    return
  fi

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$selected"
  else
    tmux attach-session -t "$selected"
  fi
}
