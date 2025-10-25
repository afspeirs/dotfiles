DOTFILES_DIR="$HOME/dotfiles/shell"

# Source all function files, if the directory exists.
if [[ -d "$DOTFILES_DIR/functions" ]]; then
  for function_file in "$DOTFILES_DIR/functions/"*.sh; do
    source "$function_file"
  done
fi

# Source aliases, if the file exists.
if [[ -f "$DOTFILES_DIR/.aliases.sh" ]]; then
  source "$DOTFILES_DIR/.aliases.sh"
fi

# Source the prompt setup, if the file exists.
if [[ -f "$DOTFILES_DIR/.prompt.sh" ]]; then
  source "$DOTFILES_DIR/.prompt.sh"
fi

if [ -n "$ZSH_VERSION" ]; then
  # Source Zsh options, if the file exists.
  if [[ -f "$DOTFILES_DIR/.zsh_options.sh" ]]; then
    source "$DOTFILES_DIR/.zsh_options.sh"
  fi

  # Enable completions for custom functions in Zsh
  fpath=($HOME/dotfiles/shell/completions $fpath)
  source "$HOME/dotfiles/shell/completions/_custom_completions.sh"
  autoload -Uz compinit
  compinit
fi
