function dotfiles() {
  local dotfiles_dir="$HOME/dotfiles"

  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Manage the dotfiles repository.

Usage:
  $ dotfiles bootstrap [-d]  # Run the bootstrap script (supports --dry-run / -d)
  $ dotfiles open            # Open the dotfiles repo
  $ dotfiles pull            # Pull the latest changes from the dotfiles repo
  $ dotfiles stow            # Re-run stow for selected packages
  $ dotfiles reload          # Reload the shell
  $ dotfiles -h              # Show this help message
  $ dotfiles                 # Same as -h

Aliases:
$(
  if [ -f "$dotfiles_dir/.zshrc.d/.aliases.sh" ]; then
    awk -F'alias ' '/^ *alias / && !/alias edit/ { sub(/=.*/, "", $2); print "  $ " $2 }' "$dotfiles_dir/.zshrc.d/.aliases.sh"
  elif [ -f "$HOME/.aliases.sh" ]; then
    awk -F'alias ' '/^ *alias / && !/alias edit/ { sub(/=.*/, "", $2); print "  $ " $2 }' "$HOME/.aliases.sh"
  fi
)

Functions:      # Use -h with any function below to show help
$(
  if [ -d "$dotfiles_dir/shell/.zshrc.d/functions" ]; then
    find "$dotfiles_dir/shell/.zshrc.d/functions" -name "*.zsh" -type f -exec basename {} .zsh \; |
      grep -v -E '^(dotfiles|exists)$' | sort | sed 's/^/  $ /'
  fi
)
EOF
    return 0
  fi

  case "$1" in
    "bootstrap")
      shift
      "$dotfiles_dir/bootstrap.sh" "$@"
      ;;
    "open")
      if command -v project >/dev/null 2>&1; then
        project "$dotfiles_dir"
      else
        cd "$dotfiles_dir" || return 1
      fi
      ;;
    "pull")
      echo "📥 Pulling latest dotfiles..."
      git -C "$dotfiles_dir" pull
      ;;
    "reload")
      echo "🔄 Reloading shell..."
      exec "$SHELL"
      ;;
    "stow")
      echo "🔗 Re-linking dotfiles..."
      (
        cd "$dotfiles_dir" || { echo "❌ Could not navigate to $dotfiles_dir. Aborting stow."; return 1; }

        local config_file="$dotfiles_dir/.stowed_packages"
        local packages=()

        if [ -f "$config_file" ]; then
          while IFS= read -r line; do
            [ -n "$line" ] && packages+=("$line")
          done < "$config_file"
        else
          # Fallback to stowing all directory packages if no saved state
          packages=( $(find . -maxdepth 1 -mindepth 1 -type d ! -name '.*' -exec basename {} \;) )
        fi

        if [ ${#packages[@]} -eq 0 ]; then
          echo "⚠️ No packages found to stow."
          return 1
        fi

        for pkg in "${packages[@]}"; do
          echo "  -> Restowing: $pkg"
          stow --restow --target="$HOME" "$pkg"
        done
        echo "✅ Stow sync complete."
      )
      ;;
    *)
      echo "🔴 Unknown option: $1"
      echo "   Run 'dotfiles -h' for usage."
      return 1
      ;;
  esac
}
