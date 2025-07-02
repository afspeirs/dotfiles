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
Manage the dotfiles repository.

Usage:
  \$ df open            # Open the dotfiles repo in VS Code (if available) or .bash_aliases in nano
  \$ df pull            # Pull the latest changes from the dotfiles repo
  \$ df -h              # Show this help message
  \$ df                 # Same as -h

Aliases:
$(grep '^alias ' ~/dotfiles/.bash_aliases 2>/dev/null | grep -v 'alias edit' | awk -F'[ =]' '{print "  \$ "$2}')

Functions:      # Use -h with any function below to show help
$(grep '^function ' ~/dotfiles/.bash_aliases 2>/dev/null | grep -v 'function df' | grep -v 'function exists' | awk -F'[ (){]' '{print "  \$ "$2}')
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
      echo "Run 'df -h' for usage."
      return 1
      ;;
  esac
}

function eachFolder() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Run a command in each subfolder of the current directory.

Usage:
  \$ eachFolder <command> [args...]   # Run a command in each subfolder
  \$ eachFolder -h                    # Show this help message
  \$ eachFolder                       # Same as -h

Example:
  \$ eachFolder ls -la       # Lists contents of each subfolder in long format

Notes:
  - Only directories in the current folder are targeted.
  - Commands are run from within each subfolder.
EOF
    return 0
  fi

  for dir in */; do
    [ -d "$dir" ] || continue
    echo "Running in: $dir"
    (cd "$dir" && "$@")
  done
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
  \$ exists code
  \$ exists code && echo "VS Code is installed"
  \$ exists git || echo "Git is not installed"


Returns:
  - Exit code 0 if the command exists
  - Exit code 1 if the command does not exist
EOF
    return 0
  fi

  if command -v "$1" >/dev/null 2>&1; then
    return 0
  else
    return 1
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

o() {
  if [ "$1" = "-h" ]; then
    cat <<EOF
Open a folder in the system's file explorer.

Usage:
  \$ o [path]          # Open the specified folder (or current folder if none given)
  \$ o -h              # Show this help message

Automatically detects and uses:
  - dolphin (Linux)
  - explorer.exe (WSL/Windows)
  - open (macOS)

Examples:
  \$ o                  # Opens the current directory
  \$ o ~/Downloads      # Opens the Downloads folder
EOF
    return 0
  fi

  target="${1:-.}"

  if exists dolphin; then
    dolphin "$target"
  elif exists explorer.exe; then
    explorer.exe "$target"
  elif exists open; then
    open "$target"
  else
    echo "No supported file explorer found. Please open '$target' manually."
    return 1
  fi
}

function remove_quarantine() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Remove the macOS quarantine flag from one or more files.

Usage:
  \$ remove_quarantine <file> [file2 ...]   # Remove the quarantine flag from one or more files
  \$ remove_quarantine -h                   # Show this help message
  \$ remove_quarantine                      # Same as -h

Example:
  \$ remove_quarantine ./node_modules.zip
  \$ remove_quarantine *.app

Notes:
  - This is useful for files downloaded from the internet that macOS blocks from running.
  - Only works on macOS systems with 'xattr' installed.
EOF
    return 0
  fi

  for file in "$@"; do
    if [ -e "$file" ]; then
      xattr -d com.apple.quarantine "$file" 2>/dev/null \
        && echo "Removed quarantine flag from: $file" \
        || echo "Failed to remove quarantine flag from: $file"
    else
      echo "File not found: $file"
    fi
  done
}

function yt() {
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

Examples:
  \$ yt https://youtu.be/dQw4w9WgXcQ
  \$ yt -a https://youtu.be/dQw4w9WgXcQ
  \$ yt -l https://youtu.be/dQw4w9WgXcQ

Requirements:
  - yt-dlp must be installed and available in your PATH
EOF
    return 0
  fi

  if ! command -v yt-dlp >/dev/null 2>&1; then
    echo "Error: yt-dlp is not installed. Please install it."
    return 1
  fi

  case "$1" in
    "-l")
      shift
      yt-dlp -F "$@"
      ;;
    "-a")
      shift
      yt-dlp -x --audio-format mp3 --audio-quality 0 "$@"
      ;;
    "-v")
      shift
      yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 --add-metadata "$@"
      ;;
    "*")
      yt-dlp -f bestvideo+bestaudio/best --merge-output-format mp4 --add-metadata "$@"
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
