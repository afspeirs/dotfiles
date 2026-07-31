function t() {
  if [[ "$1" == "-h" ]]; then
    cat <<'EOF'
Attach to a tmux session or create a new one.

Usage:
  t [options]

Options:
  -h    Show this help message

Examples:
  t

Behaviour:
  No sessions:
    - Creates a new tmux session.

  One session:
    - Attaches to it immediately.

  Multiple sessions:
    - Displays a numbered menu of available sessions.
    - Prompts for selection (1-N).
    - Press Enter without input to create a new session.

Notes:
  - When run inside tmux, the current client switches
    to the selected session.
  - When run outside tmux, it attaches to the selected
    session.
EOF
    return 0
  fi

  # Check if any sessions exist
  if ! tmux list-sessions &>/dev/null; then
    # No sessions, start a new one
    tmux new-session
    return
  fi

  # Get list of sessions
  local sessions
  sessions=$(tmux list-sessions -F "#{session_name}")

  # Count sessions
  local session_count
  session_count=$(echo "$sessions" | wc -l | tr -d ' ')

  # If only one session, attach to it directly
  if [[ $session_count -eq 1 ]]; then
    if [[ -n "$TMUX" ]]; then
      tmux switch-client -t "$sessions"
    else
      tmux attach-session -t "$sessions"
    fi
    return
  fi

  # Multiple sessions - let user pick
  echo "Available tmux sessions:"
  echo ""

  local session_array
  session_array=()
  local i=1

  while IFS= read -r session; do
    echo "  $i) $session"
    session_array+=("$session")
    ((i++))
  done <<< "$sessions"

  echo ""
  echo -n "Select session (1-$session_count, or Enter for new session): "

  read -r choice

  # If empty, create new session
  if [[ -z "$choice" ]]; then
    tmux new-session
    return
  fi

  # Validate input is a number
  if ! [[ "$choice" =~ ^[0-9]+$ ]] || [[ $choice -lt 1 ]] || [[ $choice -gt $session_count ]]; then
    echo "Invalid selection"
    return 1
  fi

  # Attach to selected session (zsh arrays start at 1)
  local selected_session="${session_array[$choice]}"

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$selected_session"
  else
    tmux attach-session -t "$selected_session"
  fi
}
