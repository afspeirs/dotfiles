function dotfiles() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Manage the dotfiles repository.

Usage:
  $ dotfiles open            # Open the dotfiles repo in VS Code (if available) or navigates to the dotfiles repo
  $ dotfiles pull            # Pull the latest changes from the dotfiles repo
  $ dotfiles reload          # Reload the shell
  $ dotfiles -h              # Show this help message
  $ dotfiles                 # Same as -h

Aliases:
$(awk -F'alias ' '/^ *alias / && !/alias edit/ { sub(/=.*/, "", $2); print "  $ " $2 }' $DOTFILES_DIR/.aliases.sh)

Functions:      # Use -h with any function below to show help
$(
  find $DOTFILES_DIR/functions -name "*.sh" -type f -exec basename {} .sh \; |
  grep -v -E '^(dotfiles|exists)$' | sort | sed 's/^/  $ /'
)
EOF
    return 0
  fi

  case "$1" in
    "open")
      if exists code; then
        code ~/dotfiles
      else
        cd ~/dotfiles
      fi
      ;;
    "pull")
      git -C ~/dotfiles pull
      ;;
    "reload")
      echo "Reloading shell..."
      exec $SHELL
      ;;
    "stow")
      echo "re-link dotfiles repo files"
      stow ~/dotfiles/loader
      ;;
    *)
      echo "🔴 Unknown option: $1"
      echo "   Run 'dotfiles -h' for usage."
      return 1
      ;;
  esac
}
