# dotfiles

This directory contains the dotfiles for my system.

## Installation

To get started, you can run the `bootstrap.sh` script directly from the repository. This will clone the repository to `~/dotfiles` if it doesn't exist, and then proceed with the setup.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/afspeirs/dotfiles/main/bootstrap.sh)"
```

### Dependencies

The script checks for the following dependencies:

- `ffmpeg`
- `ghostty`
- `git`
- `neovim`
- `stow`
- `yt-dlp`

### Stow the Dotfiles

This repository uses `stow` to create symlinks for the dotfiles.

```bash
stow loader
```

### Source the Loader Script

The `bootstrap.sh` script will attempt to automatically configure your shell (`.bashrc` or `.zshrc`) to source the `.dotfiles_loader.sh` file. If the script cannot detect your shell or if you prefer to do it manually, add the following to your shell's configuration file:

```bash
# Start dotfiles loader
if [ -f "$HOME/.dotfiles_loader.sh" ]; then
  source "$HOME/.dotfiles_loader.sh"
fi
# End dotfiles loader
```

## Platform-Specific Instructions

### Windows

If you are on Windows, you cannot use `stow` (unless you are using WSL). Since there is just a `.dotfiles_loader.sh` file, you can create a symbolic link.

As an administrator, run the below script, making sure to update the paths to be correct for your computer:

```bash
mklink "\Users\<USERNAME>\.dotfiles_loader.sh" "\Users\<USERNAME>\PATH\TO\FOLDER\dotfiles\loader\.dotfiles_loader.sh"
```
