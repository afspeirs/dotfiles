# https://stackoverflow.com/a/34143401
exists() {
  command -v "$1" >/dev/null 2>&1
}

df() {
  if [ "$1" = "pull" ]; then
    git -C ~/dotfiles pull
  elif [ "$1" = "open" ]; then
    if exists code; then
      code ~/dotfiles
    else
      nano ~/dotfiles/.bash_aliases
    fi
  else
    echo "Usage: df [pull|open]"
    echo "  $ df # show this help text"
    echo "  $ df pull # pulls the latest changes from the repo"
    echo "  $ df open # opens the dotfiles repo in vscode (if available)"
    echo "            # or opens the .bash_aliases file in nano"
  fi
}

# Open current folder in file explorer
# usage: o
o() {
  if exists dolphin; then
    dolphin .
  elif exists explorer.exe; then
    explorer.exe .
  else
    open .
  fi
}
