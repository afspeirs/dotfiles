# Set directory base to ~/.zshrc.d (where Stow links it)
DOTFILES_DIR="$HOME/.zshrc.d"

# 1. Source all function files (.zsh extension)
if [[ -d "$DOTFILES_DIR/functions" ]]; then
  for function_file in "$DOTFILES_DIR/functions/"*.zsh(N); do
    source "$function_file"
  done
fi

# 2. Source aliases
if [[ -f "$DOTFILES_DIR/.aliases.sh" ]]; then
  source "$DOTFILES_DIR/.aliases.sh"
fi

# 3. Source prompt setup if Starship isn't active
# if exists starship; then
#   eval "$(starship init zsh)"
# else
  if [[ -f "$DOTFILES_DIR/.prompt.sh" ]]; then
    source "$DOTFILES_DIR/.prompt.sh"
  fi
# fi

# 4. Zsh-specific options and completions
if [ -n "$ZSH_VERSION" ]; then
  if [[ -f "$DOTFILES_DIR/.zsh_options.sh" ]]; then
    source "$DOTFILES_DIR/.zsh_options.sh"
  fi

  # Add custom completions directory to fpath
  if [[ -d "$DOTFILES_DIR/completions" ]]; then
    fpath=("$DOTFILES_DIR/completions" $fpath)
    if [[ -f "$DOTFILES_DIR/completions/_custom_completions.zsh" ]]; then
      source "$DOTFILES_DIR/completions/_custom_completions.zsh"
    fi
    autoload -Uz compinit
    compinit
  fi

  if exists fzf; then
    source <(fzf --zsh)
  fi
fi

# 5. Local machine overrides
if [[ -f "$HOME/.dotfiles_loader.local.sh" ]]; then
  source "$HOME/.dotfiles_loader.local.sh"
fi
