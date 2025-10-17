function exists() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
Check if a command exists on the system (with optional negation).

Usage:
  $ exists <command>       # Exit 0 if command exists, 1 if not
  $ exists ! <command>     # Exit 0 if command does NOT exist, 1 if it does
  $ exists -h              # Show this help message
  $ exists                 # Same as -h

Examples:
  $ exists code
  $ exists code && echo "VS Code is installed"
  $ exists git || echo "Git is not installed"
  $ exists ! docker && echo "Docker is NOT installed"

Returns:
  - Exit code 0 if the condition is true
  - Exit code 1 if the condition is false
EOF
    return 0
  fi

  local negate=0
  local cmd

  if [ "$1" = "!" ]; then
    negate=1
    shift
  fi

  cmd="$1"

  if command -v "$cmd" >/dev/null 2>&1; then
    if [ $negate -eq 1 ]; then
      return 1 # Negated: fail because it exists
    else
      return 0
    fi
  else
    if [ $negate -eq 1 ]; then
      return 0 # Negated: success because it does not exist
    else
      return 1
    fi
  fi
}
