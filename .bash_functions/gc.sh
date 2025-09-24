function gc() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Clone a Git repository and open it in Visual Studio Code.

Usage:
  $ gc <git-repo-url>  # Clone the repo and open it in VS Code
  $ gc -h              # Show this help message
  $ gc                 # Same as -h

Example:
  $ gc https://github.com/user/repo.git
EOF
    return 0
  fi

  repo_name=$(basename -s .git "$1")

  git clone "$1"

  if [ $? -ne 0 ]; then
    echo "🔴 Error: Failed to clone repository."
    return 1
  fi

  if exists code; then
    code "$repo_name"
  else
    o "$repo_name"
  fi
}
