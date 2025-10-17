# dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system:

### Git

```bash
sudo apt install git # Ubuntu
sudo dnf install git # Fedora
sudo zypper install git # openSUSE
```

### Stow

```bash
sudo apt install stow # Ubuntu
sudo dnf install stow # Fedora
sudo zypper install stow # openSUSE
```

## Installation

First, clone the dotfiles repo in your $HOME directory

```bash
git clone git@github.com:afspeirs/dotfiles.git
cd dotfiles
```

Then use GNU stow to create symlinks

```bash
stow loader
```

### Installation on Windows

If you are on windows you cannot use stow (unless you use WSL). As there is just a `.dotfiles_loader.sh` file we can create a symbolic link

As an admin run the below script, making sure to update the paths to be correct for your computer:

```bash
mklink "\Users\<USERNAME>\loader\.dotfiles_loader.sh" "\Users\<USERNAME>\PATH\TO\FOLDER\dotfiles\loader\.dotfiles_loader.sh"
```

### Setup `.bashrc` file

Your `.bashrc` file needs to be setup to import the `.dotfiles_loader.sh` file. To do so add the following to the `.bashrc` file:

```bash
# Load dotfiles repo

if [ -f "$HOME/.dotfiles_loader.sh" ]; then
    source "$HOME/.dotfiles_loader.sh"
fi

```
