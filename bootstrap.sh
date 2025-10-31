#!/bin/bash

# Bootstrap script for setting up dependencies for the dotfiles repository.

# TODO: Actually install the dependencies if they are not installed instead of showing how, maybe with a prompt
# This will need a helper function most likely to detect the os and download accordingly.
# I will also need to handle flatpak and custom installs

# --- Repository Cloning ---

if [ ! -d "$HOME/dotfiles" ]; then
  echo "Cloning dotfiles repository..."
  git clone https://github.com/afspeirs/dotfiles.git "$HOME/dotfiles"
  cd "$HOME/dotfiles" || exit
else
  echo "✅ Dotfiles repository already exists."
fi

# Function to check if a command exists
function exists() {
  command -v "$1" >/dev/null 2>&1
}

# --- Dependency Checks ---

echo "Checking for required dependencies..."

# Check for ffmpeg
if exists ffmpeg; then
  echo "✅ ffmpeg is installed."
else
  echo "❌ ffmpeg is not installed. This is required for video compression."
  echo "   - macOS (with Homebrew): brew install ffmpeg"
  echo "   - Debian/Ubuntu: sudo apt-get install ffmpeg"
  echo "   - Fedora: sudo dnf install ffmpeg"
fi

# Check for fzf
if exists fzf; then
  echo "✅ fzf is installed."
else
  echo "❌ fzf is not installed"
  echo "   - macOS (with Homebrew): brew install fzf"
  echo "   - Debian/Ubuntu: sudo apt-get install fzf"
  echo "   - Fedora: sudo dnf install fzf"
fi

# Check for Ghostty
if exists ghostty; then
  echo "✅ Ghostty is installed."
else
  echo "❌ Ghostty is not installed. This is the preferred terminal."
  echo "   - See installation instructions at https://github.com/ghostty-org/ghostty"
fi

# Check for Git
if exists git; then
  echo "✅ Git is installed."
else
  echo "❌ Git is not installed. Please install it to continue."
  # Instructions for different package managers
  echo "   - macOS (with Homebrew): brew install git"
  echo "   - Debian/Ubuntu: sudo apt-get install git"
  echo "   - Fedora: sudo dnf install git"
fi

# Check for Neovim
if exists nvim; then
  echo "✅ Neovim is installed."
else
  echo "❌ Neovim is not installed. This is required for the Neovim configuration."
  echo "   - macOS (with Homebrew): brew install neovim"
  echo "   - Debian/Ubuntu: sudo apt-get install neovim"
  echo "   - Fedora: sudo dnf install neovim"
fi

if exists starship; then
  echo "✅ starship is installed."
else
  echo "❌ starship is not installed. This is required for the improved prompt configuration."
  echo "   - macOS (with Homebrew): brew install starship"
  echo "   - Linux: curl -sS https://starship.rs/install.sh | sh"
fi

# Check for Stow
if exists stow; then
  echo "✅ Stow is installed."
else
  echo "❌ Stow is not installed. This is required for managing dotfiles."
  echo "   - macOS (with Homebrew): brew install stow"
  echo "   - Debian/Ubuntu: sudo apt-get install stow"
  echo "   - Fedora: sudo dnf install stow"
fi

# Check for yt-dlp
if exists yt-dlp; then
  echo "✅ yt-dlp is installed."
else
  echo "❌ yt-dlp is not installed. This is required for downloading YouTube videos."
  echo "   - macOS (with Homebrew): brew install yt-dlp"
  echo "   - Debian/Ubuntu: sudo apt-get install yt-dlp"
  echo "   - Fedora: sudo dnf install yt-dlp"
fi

# TODO: Check if the "Fira Code" font is installed and the nerd font too?
# Not sure if I will be able to do that or if I can just say this is how you install it
# curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz

echo "Dependency check complete."

# --- Shell Configuration ---

echo "Configuring shell..."

LOADER_SNIPPET='''
# Start dotfiles loader
if [ -f "$HOME/.dotfiles_loader.sh" ]; then
  source "$HOME/.dotfiles_loader.sh"
fi
# End dotfiles loader
'''

RC_FILE=""
if [[ "$SHELL" == *"/bash" ]]; then
  RC_FILE="$HOME/.bashrc"
elif [[ "$SHELL" == *"/zsh" ]]; then
  RC_FILE="$HOME/.zshrc"
fi

if [ -n "$RC_FILE" ]; then
  if grep -q "# Start dotfiles loader" "$RC_FILE"; then
    echo "✅ Shell configuration already exists in $RC_FILE."
  else
    echo "Adding dotfiles loader to $RC_FILE..."
    echo -e "$LOADER_SNIPPET" >> "$RC_FILE"
    echo "✅ Shell configuration updated."
    echo "   Please restart your shell or run 'source $RC_FILE' to apply the changes."
  fi
else
  echo "⚠️ Could not detect shell. Please add the following to your shell configuration file:"
  echo -e "$LOADER_SNIPPET"
fi
