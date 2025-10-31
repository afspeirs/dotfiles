#!/bin/bash

# Bootstrap script for setting up dependencies for the dotfiles repository.

# --- OS Detection ---

os_type=""
if [ -f /etc/os-release ]; then
  . /etc/os-release
  os_type=$ID
elif [ "$(uname)" == "Darwin" ]; then
  os_type="macos"
fi

echo "🧠 Detected OS: $os_type"

# --- Install Helper Function ---

function install_package() {
  pkg="$1"
  case "$os_type" in
    ubuntu|debian)
      sudo apt-get update && sudo apt-get install -y "$pkg"
      ;;
    fedora)
      sudo dnf install -y "$pkg"
      ;;
    arch)
      sudo pacman -Sy "$pkg"
      ;;
    macos)
      brew install "$pkg"
      ;;
    *)
      echo "⚠️ Unsupported OS. Please install $pkg manually."
      ;;
  esac
}

# --- Flatpak Install Helper ---

function install_flatpak() {
  app="$1"
  if command -v flatpak >/dev/null 2>&1; then
    flatpak install -y flathub "$app"
  else
    echo "❌ Flatpak is not installed. Cannot install $app via Flatpak."
  fi
}

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

packages=(ffmpeg fzf git nvim starship stow yt-dlp)

for pkg in "${packages[@]}"; do
  if exists "$pkg"; then
    echo "✅ $pkg is installed."
  else
    echo "❌ $pkg is not installed. Installing..."
    install_package "$pkg"
  fi
done

# Ghostty (custom install)
if exists ghostty; then
  echo "✅ Ghostty is installed."
else
  echo "❌ Ghostty is not installed. This is the preferred terminal."
  echo "   - See installation instructions at https://github.com/ghostty-org/ghostty"
fi

# --- Font Installation ---
# TODO: Check for font better, it give false errors currently
FONT_DIR="$HOME/.local/share/fonts"
FONT_FILE="$FONT_DIR/FiraCode-Regular.ttf"
if [ ! -f "$FONT_FILE" ]; then
  echo "❌ Fira Code Nerd Font is not installed."
  read -p "   Would you like to download it now? (y/N): " install_font
  if [[ "$install_font" =~ ^[Yy]$ ]]; then
    echo "Download Fira Code Nerd Font..."
    # mkdir -p "$FONT_DIR"
    curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz
    # tar -xf FiraCode.tar.xz -C "$FONT_DIR"
    # fc-cache -fv
    echo "✅ Font downloaded."
  else
    echo "⏭️ Skipping font installation."
  fi
else
  echo "✅ Fira Code Nerd Font is already installed."
fi

echo "Dependency check complete."

# --- Shell Configuration ---

echo "Configuring shell..."

LOADER_SNIPPET='
# Start dotfiles loader
if [ -f "$HOME/.dotfiles_loader.sh" ]; then
  source "$HOME/.dotfiles_loader.sh"
fi
# End dotfiles loader
'

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
