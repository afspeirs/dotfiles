alias edit=nvim

# Find and delete all .DS_Store files
alias delete_ds="find . -name '.DS_Store' -type f -delete"

if exists brew; then
  # Start the mysql service
  alias mysql_start="brew services start mysql"
fi

if exists docker; then
  # Prune all unused docker objects
  alias docker_prune="docker system prune -a --volumes"
fi

if exists git; then
  # List all git branches
  alias gb="git branch -r | grep -v '\->' | grep 'origin/' | sed 's/origin\///g'"
  # Reset the last git commit
  alias gr="git reset --soft HEAD~1"
fi

if exists lazygit; then
  alias lg="lazygit"
fi

if exists tmux; then
  alias t="tmux"
  alias ta="tmux a"
fi
