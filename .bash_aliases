# https://stackoverflow.com/a/34143401
exists() {
  command -v "$1" >/dev/null 2>&1
}

alias {df-pull,dotfiles-pull}="git -C ~/dotfiles pull"

if exists code; then
  alias {df,dotfiles}='code ~/dotfiles'
else
  alias {df,dotfiles}='nano ~/dotfiles/.bash_aliases'
fi

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
