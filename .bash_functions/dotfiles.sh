function dotfiles() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Manage the dotfiles repository.

Usage:
  $ dotfiles open            # Open the dotfiles repo in VS Code (if available) or .bash_aliases in nano
  $ dotfiles pull            # Pull the latest changes from the dotfiles repo
  $ dotfiles -h              # Show this help message
  $ dotfiles                 # Same as -h

Aliases:
$(grep '^alias ' ~/dotfiles/.bash_aliases 2>/dev/null | grep -v 'alias edit' | awk -F'[ =]' '{print "  $ "$2}')

Functions:      # Use -h with any function below to show help
$(
  find ~/dotfiles/.bash_functions -name "*.sh" -type f 2>/dev/null |
  while IFS= read -r file; do
    base=$(basename "$file" .sh)
    echo "$base" # Just output the base name
  done | grep -v -E '^(dotfiles|exists)$' | sort | sed 's/^/  $ /' # Filter, sort, then add formatting
)
EOF
    return 0
  fi

  case "$1" in
    "open")
      if exists code; then
        code ~/dotfiles
      else
        nano ~/dotfiles/.bash_aliases
      fi
      ;;
    "pull")
      git -C ~/dotfiles pull
      ;;
    *)
      echo "Unknown option: $1"
      echo "Run 'df -h' for usage."
      return 1
      ;;
  esac
}
