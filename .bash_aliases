# Aliases

alias edit=nano

alias delete_ds="find . -name '.DS_Store' -type f -delete"
alias docker-prune="docker system prune -a --volumes"
alias gb="git branch -r | grep -v '\->' | grep 'origin/' | sed 's/origin\///g'"
alias gr="git reset --soft HEAD~1"
alias ip='ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '"'"'{print $2}'"'"
alias mysql_start="brew services start mysql"

# Functions

function df() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Manage the dotfiles repo

Usage:
  \$ df open            # Open the dotfiles repo in VS Code (if available) or open .bash_aliases in nano
  \$ df pull            # Pull the latest changes from the repo
  \$ df -h              # Show this help message
  \$ df                 # Same as -h

Aliases:
$(grep '^alias ' ~/.bash_aliases | grep -v 'alias edit' | awk -F'[ =]' '{print "  \$ "$2}')

Functions:      # Use -h with any function below to show help
$(grep '^function ' ~/.bash_aliases | grep -v 'function df' | grep -v 'function exists' | awk -F'[ () {]' '{print "  \$ "$2}')
EOF
    return 0
  fi

  case "$1" in
    "open")
      if exists code; then
        code ~/dotfiles
      else
        nano ~/dotfiles/.bash_aliases
      fi
      ;;
    "pull")
      git -C ~/dotfiles pull
      ;;
    *)
      echo "Unknown option: $1"
      return 1
      ;;
  esac
}

function eachFolder() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Run a command in each subfolder of the current directory.

Usage:
  \$ eachFolder <command>       # Run a command in each subfolder of the current directory.
  \$ eachFolder -h              # Show this help message
  \$ eachFolder                 # Same as -h

Example:
  eachFolder ls        # Lists contents of each subfolder
EOF
  else
    ls -d */ | xargs -I {} bash -c "cd '{}' && $@"
  fi
}

function exists() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Check if a command exists on the system.

Usage:
  \$ exists <command>       # Check if a command exists on the system
  \$ exists -h              # Show this help message
  \$ exists                 # Same as -h

Example:
  \$ exists code          # Checks if VS Code is installed
EOF
  else
    command -v "$1" >/dev/null 2>&1
  fi
}

function gc() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Clone a Git repository and open it in Visual Studio Code.

Usage:
  \$ gc <git-repo-url>  # Clone the repo and open it in VS Code
  \$ gc -h              # Show this help message
  \$ gc                 # Same as -h

Example:
  \$ gc https://github.com/user/repo.git
EOF
    return 0
  fi

  repo_name=$(basename -s .git "$1")

  git clone "$1"

  if [ $? -ne 0 ]; then
    echo "Failed to clone repository."
    return 1
  fi

  if exists code; then
    code "$repo_name"
  else
    o "$repo_name"
  fi
}

function loopFiles() {
  filenames=(
    "page-1.hbs"
    "page-2.hbs"
  )

  # Loop over the array and create each folder
  for element in "${filenames[@]}"; do
    mkdir "$element"
    echo "$element"
  done
}

function o() {
  if [ "$1" = "-h" ]; then
    cat <<EOF
Open the current folder in a file explorer window.

Usage:
  \$ o                 # Open the current folder in a file explorer window
  \$ o -h              # Show this help message

Automatically detects and uses:
  - dolphin (Linux)
  - explorer.exe (WSL/Windows)
  - open (macOS)
EOF
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
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Remove the macOS quarantine flag from a file.

Usage:
  \$ remove_quarantine <file>          # Remove the quarantine flag from a file
  \$ remove_quarantine -h              # Show this help message
  \$ remove_quarantine                 # Same as -h

Example:
  \$ remove_quarantine ./node_modules.zip
EOF
  else
    xattr -d com.apple.quarantine "$1"
  fi
}

function yt() {
  local url=""

  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Download YouTube audio (MP3) or video (MP4) using yt-dlp.

Usage:
  \$ yt <URL>           # Download best video+audio (MP4) [default]
  \$ yt -l <URL>        # List available formats
  \$ yt -a <URL>        # Download best audio only (MP3)
  \$ yt -v <URL>        # Download best 1080p video+audio (MP4)
  \$ yt -h              # Show this help message
  \$ yt                 # Same as -h

Requirements:
  - yt-dlp must be installed and available in your PATH
EOF
    return 0
  fi

  if ! command -v yt-dlp &> /dev/null; then
    echo "Error: yt-dlp is not installed. Please install it."
    return 1
  fi

  case "$1" in
    -l)
      yt-dlp -F "$2"
      ;;
    -a)
      yt-dlp -x --audio-format mp3 --audio-quality 0 "$2"
      ;;
    -v)
      yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 --add-metadata "$2"
      ;;
    *)
      yt-dlp -f bestvideo+bestaudio/best --merge-output-format mp4 --add-metadata "$1"
      ;;
  esac
}

function zipper() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Zip each folder or the contents of each folder within the current directory.

Usage:
  \$ zipper -c              # Zip the contents of each folder (excluding the folder)
  \$ zipper -i              # Zip each folder (including the folder itself)
  \$ zipper -h              # Show this help message
  \$ zipper                 # Same as -h

Notes:
  - All .zip files in the current directory will be removed before zipping.
  - Output files will be named after each folder (e.g., folder.zip).
EOF
    return 0
  fi

  rm -f ./*.zip

  case "$1" in
    -c)
      for i in */; do (cd "$i"; zip -r "../${i%/}.zip" .); done
      ;;
    -i)
      for i in */; do zip -r "${i%/}.zip" "$i"; done
      ;;
    *)
      echo "Unknown option: $1"
      return 1
      ;;
  esac
}
