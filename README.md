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
stow .
```

### Installation on Windows

If you are on windows you cannot use stow (unless you use WSL). As there is just a `.bash_aliases` file we can create a symbolic link

As an admin run the below script, making sure to update the paths to be correct for your computer:

```bash
mklink "\Users\<USERNAME>\.bash_aliases" "\Users\<USERNAME>\PATH\TO\FOLDER\dotfiles\.bash_aliases"
```

### Setup `.bashrc` file

Your `.bashrc` file needs to be setup to import the `.bash_aliases` file. To do so add the following to the `.bashrc` file:

```bash
if [ -f "$HOME/.bash_aliases" ]; then
  source "$HOME/.bash_aliases"
fi
```
