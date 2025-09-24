# Aliases

alias edit=nano

alias delete_ds="find . -name '.DS_Store' -type f -delete"
alias docker_prune="docker system prune -a --volumes"
alias gb="git branch -r | grep -v '\->' | grep 'origin/' | sed 's/origin\///g'"
alias gr="git reset --soft HEAD~1"
alias ip='ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '"'"'{print $2}'"'"
alias mysql_start="brew services start mysql"

# Functions

if [ -d "$HOME/dotfiles/.bash_functions" ]; then
  for file in "$HOME/dotfiles/.bash_functions/"*.sh; do
    if [ -f "$file" ]; then
      source "$file"
    fi
  done
fi
