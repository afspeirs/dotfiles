# dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system:

### Git

```bash
sudo apt install git
```

### Stow

```bash
sudo apt install stow
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
