#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$DOTFILES_DIR/.stowed_packages"

# Default Stow flags array
STOW_FLAGS=(--restow)
DRY_RUN=false

# --- Parse Command-Line Flags ---
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dry-run)
      DRY_RUN=true
      STOW_FLAGS=(-n -v --restow)
      shift
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done
set -- "${POSITIONAL_ARGS[@]}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}==> Starting Dotfiles Bootstrap...${NC}\n"

if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}===============================================${NC}"
  echo -e "${YELLOW}  RUNNING IN DRY-RUN MODE (No changes made)    ${NC}"
  echo -e "${YELLOW}===============================================${NC}\n"
fi

# --- 1. OS Detection ---
os_type=""
if [ -f /etc/os-release ]; then
  . /etc/os-release
  os_type=$ID
elif [ "$(uname)" == "Darwin" ]; then
  os_type="macos"
fi

echo -e "🧠 Detected OS: ${GREEN}$os_type${NC}\n"

exists() {
  command -v "$1" >/dev/null 2>&1
}

install_package() {
  pkg="$1"

  # Normalize package names for macOS / Homebrew
  if [ "$os_type" == "macos" ]; then
    [[ "$pkg" == "nvim" ]] && pkg="neovim"
  fi

  [ "$DRY_RUN" = true ] && { echo -e "  ${YELLOW}[DRY-RUN] Would install package: $pkg${NC}"; return 0; }

  case "$os_type" in
    ubuntu|debian) sudo apt-get update && sudo apt-get install -y "$pkg" ;;
    fedora)        sudo dnf install -y "$pkg" ;;
    arch|steamos)
      if ! exists yay; then
        sudo pacman -S --needed --noconfirm git base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        (cd /tmp/yay && makepkg -si --noconfirm)
        rm -rf /tmp/yay
      fi
      yay -S --noconfirm "$pkg"
      ;;
    macos) brew install "$pkg" ;;
    *)     echo -e "${RED}⚠️ Unsupported OS. Please install $pkg manually.${NC}" ;;
  esac
}

# Ensure GNU Stow is installed first
if ! exists stow; then
  echo -e "${YELLOW}GNU Stow not found. Installing...${NC}"
  install_package stow
fi

# --- 2. Interactive Package Selection ---
cd "$DOTFILES_DIR"

PREVIOUS_SELECTIONS=""
[ -f "$CONFIG_FILE" ] && PREVIOUS_SELECTIONS=$(cat "$CONFIG_FILE")

# Discover all stow package folders (directories that aren't hidden)
AVAILABLE_PACKAGES=()
while IFS= read -r dir; do
  [ -n "$dir" ] && AVAILABLE_PACKAGES+=("$dir")
done < <(find . -maxdepth 1 -mindepth 1 -type d ! -name '.*' -exec basename {} \;)

SELECTED_PACKAGES=()

echo -e "${BLUE}==> Select configuration packages to Stow:${NC}"
echo -e "Press ${BLUE}Enter${NC} to accept default, or type ${BLUE}y/n${NC}:\n"

for pkg in "${AVAILABLE_PACKAGES[@]}"; do
  if echo "$PREVIOUS_SELECTIONS" | grep -qx "$pkg"; then
    default_prompt="[Y/n]"
    is_default_yes=true
  else
    default_prompt="[y/N]"
    is_default_yes=false
  fi

  read -p "Stow '$pkg'? $default_prompt: " choice < /dev/tty

  case "$choice" in
    [Yy]* ) SELECTED_PACKAGES+=("$pkg") ;;
    [Nn]* ) echo "  Skipping $pkg" ;;
    "" )
      if [ "$is_default_yes" = true ]; then
        SELECTED_PACKAGES+=("$pkg")
      else
        echo "  Skipping $pkg"
      fi
      ;;
    * ) echo "  Skipping $pkg" ;;
  esac
done

# Save selection to local config file (only if not dry-run)
if [ "$DRY_RUN" = false ]; then
  printf "%s\n" "${SELECTED_PACKAGES[@]}" > "$CONFIG_FILE"
fi

# --- 3. Dependency Check for Selected Packages ---
echo -e "\n${BLUE}==> Checking dependencies for selected packages...${NC}"

# Check base CLI tool dependencies only if 'shell' configuration was selected
if [[ " ${SELECTED_PACKAGES[*]} " =~ " shell " ]]; then
  BASE_DEPS=(
    ffmpeg
    fzf
    git
    ydiff
    yt-dlp
  )
  for bin in "${BASE_DEPS[@]}"; do
    if ! exists "$bin"; then
      echo -e "  ${YELLOW}Missing shell dependency: $bin${NC}"
      install_package "$bin" || true
    else
      echo -e "  ✅ $bin is installed"
    fi
  done
fi

for pkg in "${SELECTED_PACKAGES[@]}"; do
  case "$pkg" in
    ghostty)  dep="ghostty" ;;
    git)      dep="timg" ;;
    lazygit)  dep="lazygit" ;;
    nvim)     dep="nvim" ;;
    starship) dep="starship" ;;
    tmux)     dep="tmux" ;;
    zed)      dep="zed" ;;
    *)        dep="" ;;
  esac

  if [ -n "$dep" ]; then
    if exists "$dep"; then
      echo -e "  ✅ $dep is installed (for $pkg)"
    else
      echo -e "  ${YELLOW}❌ $dep missing for $pkg${NC}"
      install_package "$dep" || true
    fi
  fi
done

if [[ " ${SELECTED_PACKAGES[*]} " =~ " tmux " ]]; then
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo -e "${YELLOW}Installing Tmux Plugin Manager (TPM)...${NC}"
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${YELLOW}[DRY-RUN] Would clone TPM to ~/.tmux/plugins/tpm${NC}"
    else
      git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
  fi
fi

# --- 4. Apply Stow Symlinks ---
echo -e "\n${BLUE}==> Stowing selected packages into $HOME...${NC}"

mkdir -p "$HOME/.config"

for pkg in "${SELECTED_PACKAGES[@]}"; do
  echo -e "${GREEN}Stowing: $pkg${NC}"
  stow "${STOW_FLAGS[@]}" --target="$HOME" "$pkg"
done

# --- 5. Shell Loader Setup ---
RC_FILE=""
[[ "$SHELL" == *"/bash" ]] && RC_FILE="$HOME/.bashrc"
[[ "$SHELL" == *"/zsh" ]] && RC_FILE="$HOME/.zshrc"

LOADER_SNIPPET='
# --- Start Dotfiles Loader ---
if [[ -f "$HOME/.zshrc.d/loader.zsh" ]]; then
  source "$HOME/.zshrc.d/loader.zsh"
fi
# --- End Dotfiles Loader ---
'

if [ -n "$RC_FILE" ]; then
  if ! grep -q "Start Dotfiles Loader" "$RC_FILE"; then
    if [ "$DRY_RUN" = true ]; then
      echo -e "\n${YELLOW}[DRY-RUN] Would add loader hook to $RC_FILE${NC}"
    else
      echo -e "\n${BLUE}Adding ~/.zshrc.d loader hook to $RC_FILE...${NC}"
      echo -e "$LOADER_SNIPPET" >> "$RC_FILE"
    fi
  fi
fi

if [ "$DRY_RUN" = true ]; then
  echo -e "\n${YELLOW}Dry run complete. No files were modified.${NC}"
else
  echo -e "\n${GREEN}🎉 Bootstrap complete! Your dotfiles are linked and dependencies installed.${NC}"
fi
