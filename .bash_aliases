# Aliases

alias edit=nano
alias delete_ds="find . -name '.DS_Store' -type f -delete"
alias mysql_start="brew services start mysql"
alias ip='ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '"'"'{print $2}'"'"

# Functions

# a function to help manage the code within this repo
# usage: $ df [pull|open]
function df() {
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

# run a commend for each sub folder
# usage: $ eachFolder ls
function eachFolder() {
  ls -d */ | xargs -I {} bash -c "cd '{}' && $@"
}

# check if a command exists
# link: https://stackoverflow.com/a/34143401
# usage: $ exists code
function exists() {
  command -v "$1" >/dev/null 2>&1
}

# Open current folder in file explorer
# usage: $ o
function o() {
  if exists dolphin; then
    dolphin .
  elif exists explorer.exe; then
    explorer.exe .
  else
    open .
  fi
}

# remove the quarantine flag on a file to allow the file to be used
# usage: $ remove_quarantine ./node_modules.zip
function remove_quarantine() {
  xattr -d com.apple.quarantine "$1"
}

# zip the contents of each folder within a directory
# usage: $ zipper
function zipper() {
  rm -rf .//*.zip
  for i in */; do (cd "$i"; zip -r "../${i%/}.zip" .); done
}
