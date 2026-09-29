function h() {
  if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    cat <<'EOF'
Attach to herdr, optionally switching to a workspace first.

Usage:
  h              Attach to the herdr session
  h <workspace>  Switch to the named workspace, then attach

Options:
  -h    Show this help message

Examples:
  h              # attach (or re-attach) to herdr
  h dotfiles     # jump to the "dotfiles" workspace
  h speirs.dev   # labels with dots are fine

Notes:
  - Inside herdr this switches the current client and returns. Herdr blocks
    nesting, so a new client is not started.
  - Outside herdr this focuses the workspace and then launches a client.
  - Press <prefix><1..9> to switch workspaces without leaving the keyboard.
EOF
    return 0
  fi

  if ! exists herdr; then
    echo "herdr is not installed."
    return 1
  fi

  # A bare `h` just hands the terminal to herdr, which attaches to the
  # existing session if there is one. exec replaces this shell, so the
  # return is only reached if exec fails.
  if [[ $# -eq 0 ]]; then
    exec herdr
    return 1
  fi

  local label="$1"
  shift

  if [[ $# -gt 0 ]]; then
    echo "h takes at most one workspace name."
    return 1
  fi

  local workspace_id
  workspace_id=$(_herdr_workspace_id_by_label "$label")

  if [[ -z "$workspace_id" ]]; then
    echo "No herdr workspace named: $label"
    return 1
  fi

  herdr workspace focus "$workspace_id" >/dev/null

  # With no client on this terminal there is nothing to switch, so attach.
  if [[ "$HERDR_ENV" != "1" ]]; then
    exec herdr
  fi
}

_h_workspace_labels() {
  herdr workspace list 2>/dev/null |
    command tr '{' '\n' |
    command grep -o '"label":"[^"]*"' |
    command sed 's/^"label":"//; s/"$//' |
    LC_ALL=C command sort -u
}
