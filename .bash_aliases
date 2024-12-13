# Aliases

alias edit=nano

alias delete_ds="find . -name '.DS_Store' -type f -delete"
alias gb="git branch -r | grep -v '\->' | grep 'origin/' | sed 's/origin\///g'"
alias gr="git reset --soft HEAD~1"
alias ip='ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '"'"'{print $2}'"'"
alias mysql_start="brew services start mysql"

# Functions

function df() {
  local NC='\033[0m' # No colour
  local GREEN='\033[0;32m'

  if [ "$1" = "pull" ]; then
    git -C ~/dotfiles pull
  elif [ "$1" = "open" ]; then
    if exists code; then
      code ~/dotfiles
    else
      nano ~/dotfiles/.bash_aliases
    fi
  else
    echo "Manage the dotfiles repo"
    echo
    echo "Usage:"
    echo -e "  $ df      ${GREEN}# Show this help text${NC}"
    echo -e "  $ df pull ${GREEN}# Pull the latest changes from the repo${NC}"
    echo -e "  $ df open ${GREEN}# Open the dotfiles repo in vscode (if available)${NC}"
    echo -e "            ${GREEN}# or open the .bash_aliases file in nano${NC}"
    echo ""
    echo "Aliases:"
    grep '^alias ' ~/.bash_aliases | grep -v 'alias edit' | awk -F'[ =]' '{print "  $ "$2}'
    echo ""
    echo -e "Functions:  ${GREEN}# For each of the below functions you can pass -h to show some help text${NC}"
    grep '^function ' ~/.bash_aliases | grep -v 'function df' | grep -v 'function exists' | awk -F'[ () {]' '{print "  $ "$2}'
  fi
}

function eachFolder() {
  if [ "$1" = "-h" ]; then
    echo "Run a commend for each sub folder"
    echo
    echo "Usage:"
    echo "  $ eachFolder ls"
  else
    ls -d */ | xargs -I {} bash -c "cd '{}' && $@"
  fi
}

function exists() {
  if [ "$1" = "-h" ]; then
    echo "Check if a command exists"
    # echo "link: https://stackoverflow.com/a/34143401"
    echo
    echo "Usage:"
    echo "  $ exists code"
  else
    command -v "$1" >/dev/null 2>&1
  fi
}

function loopFiles() {
  filenames=(
    "page-1.hbs"
    "page-2.hbs"
  )

  # Loop over the array and create each file
  for element in "${filenames[@]}"
  do
    mkdir "$element"
    # touch "$element"
    echo $element
  done
}

function o() {
  if [ "$1" = "-h" ]; then
    echo "Open the current folder in a new file explorer window"
    echo
    echo "Usage:"
    echo "  $ o"
  else
    if exists dolphin; then
      dolphin .
    elif exists explorer.exe; then
      explorer.exe .
    else
      open .
    fi
  fi
}

function remove_quarantine() {
  if [ "$1" = "-h" ]; then
    echo "Remove the quarantine flag on a file to allow the file to be used"
    echo
    echo "Usage:"
    echo "  $ remove_quarantine ./node_modules.zip"
  else
    xattr -d com.apple.quarantine "$1"
  fi
}

function zipper() {
  if [ "$1" = "-h" ]; then
    echo "zip the contents of each folder within a directory"
    echo
    echo "Usage:"
    echo "  $ zipper"
  else
    rm -rf .//*.zip
    for i in */; do (cd "$i"; zip -r "../${i%/}.zip" .); done
  fi
}
