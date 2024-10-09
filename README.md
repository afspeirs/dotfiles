# dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system:

### Git

```bash
sudo apt install git
sudo zypper install git
```

### Stow

```bash
sudo apt install stow
sudo zypper install stow
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

### Setup `.bashrc` file

Your `.bashrc` file needs to be setup to import the `.bash_aliases` file. To do so add the following to the `.bashrc` file:

```bash
if [ -f "$HOME/.bash_aliases" ]; then
  source "$HOME/.bash_aliases"
fi
```
