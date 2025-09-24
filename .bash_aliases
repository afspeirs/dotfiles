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
  $ df open            # Open the dotfiles repo in VS Code (if available) or .bash_aliases in nano
  $ df pull            # Pull the latest changes from the dotfiles repo
  $ df -h              # Show this help message
  $ df                 # Same as -h

Aliases:
$(grep '^alias ' ~/dotfiles/.bash_aliases 2>/dev/null | grep -v 'alias edit' | awk -F'[ =]' '{print "  $ "$2}')

Functions:      # Use -h with any function below to show help
$(grep '^function ' ~/dotfiles/.bash_aliases 2>/dev/null | grep -v 'function df' | grep -v 'function exists' | awk -F'[ (){]' '{print "  $ "$2}')
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
  $ eachFolder <command> [args...]   # Run a command in each subfolder
  $ eachFolder -h                    # Show this help message
  $ eachFolder                       # Same as -h

Example:
  $ eachFolder ls -la       # Lists contents of each subfolder in long format

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
    cat <<'EOF'
Check if a command exists on the system (with optional negation).

Usage:
  $ exists <command>       # Exit 0 if command exists, 1 if not
  $ exists ! <command>     # Exit 0 if command does NOT exist, 1 if it does
  $ exists -h              # Show this help message
  $ exists                 # Same as -h

Examples:
  $ exists code
  $ exists code && echo "VS Code is installed"
  $ exists git || echo "Git is not installed"
  $ exists ! docker && echo "Docker is NOT installed"

Returns:
  - Exit code 0 if the condition is true
  - Exit code 1 if the condition is false
EOF
    return 0
  fi

  local negate=0
  local cmd

  if [ "$1" = "!" ]; then
    negate=1
    shift
  fi

  cmd="$1"

  if command -v "$cmd" >/dev/null 2>&1; then
    # Command exists
    if [ $negate -eq 1 ]; then
      return 1  # Negated: fail because it exists
    else
      return 0
    fi
  else
    # Command does not exist
    if [ $negate -eq 1 ]; then
      return 0  # Negated: success because it does not exist
    else
      return 1
    fi
  fi
}

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
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
Loop over an array of filenames and create a folder for each.

Usage:
  $ loopFiles file1 file2 ...      # Creates a folder for each filename
  $ loopFiles -h                   # Show this help message

Example:
  $ loopFiles page-1.hbs page-2.hbs
EOF
    return 0
  fi

  # All arguments become the array
  local filenames=("$@")

  for element in "${filenames[@]}"; do
    mkdir -p "$element"
    echo "Created: $element"
  done
}

function o() {
  if [ "$1" = "-h" ]; then
    cat <<EOF
Open a folder in the system's file explorer.

Usage:
  $ o [path]          # Open the specified folder (or current folder if none given)
  $ o -h              # Show this help message

Automatically detects and uses:
  - dolphin (Linux)
  - explorer.exe (WSL/Windows)
  - open (macOS)

Examples:
  $ o                  # Opens the current directory
  $ o ~/Downloads      # Opens the Downloads folder
EOF
    return 0
  fi

  target="${1:-.}"

  if exists dolphin; then
    dolphin "$target" > /dev/null 2>&1 &
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
  $ remove_quarantine <file> [file2 ...]   # Remove the quarantine flag from one or more files
  $ remove_quarantine -h                   # Show this help message
  $ remove_quarantine                      # Same as -h

Example:
  $ remove_quarantine ./node_modules.zip
  $ remove_quarantine *.app

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

function video_compress() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
Compress a video to H.264/AAC with sensible web-friendly defaults.

Usage:
  $ video_compress <input-file> [crf] [preset]   # Compress to <input>_compressed.mp4
  $ video_compress -h                            # Show this help message
  $ video_compress                               # Same as -h

Arguments:
  <input-file>    Path to the source video (any format ffmpeg supports)
  [crf]           Constant Rate Factor for video quality (lower = better, larger file)
                  Typical range: 18-28. Default: 23
  [preset]        x264 speed/efficiency trade-off:
                  ultrafast, superfast, veryfast, faster, fast, medium,
                  slow, slower, veryslow. Default: slow

Output:
  Writes: <input_basename>_compressed.mp4
  Example: "Holiday Clip.mov" -> "Holiday Clip_compressed.mp4"

Notes:
  - Requires: ffmpeg (https://ffmpeg.org/)
  - Uses: H.264 (libx264), AAC 128k, -movflags +faststart, and won't overwrite (-n).

Examples:
  $ video_compress input.mp4
  $ video_compress "My Clip.mov" 21 veryslow
EOF
    return 0
  fi

  local input="$1"
  local crf="${2:-23}"        # 0 (lossless) .. 51 (worst); lower = better quality/larger size
  local preset="${3:-slow}"   # ultrafast .. veryslow
  local output="${input%.*}_compressed.mp4"

  if [[ ! -f "$input" ]]; then
    echo "Error: input file '$input' not found." >&2
    return 1
  fi
  if exists ! ffmpeg; then
    echo "Error: ffmpeg is not installed or not on PATH." >&2
    return 1
  fi

  if ffmpeg -hide_banner -loglevel error -n \
      -i "$input" \
      -vcodec libx264 -crf "$crf" -preset "$preset" \
      -acodec aac -b:a 128k \
      -movflags +faststart \
      "$output"
  then
    echo "✅ Compressed video saved as: $output"
    return 0
  else
    local rc=$?
    echo "ffmpeg failed (exit code $rc)." >&2
    return $rc
  fi
}

function video_compress_all() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
Batch-compress all videos in a directory using video_compress.

Usage:
  $ video_compress_all [directory] [crf] [preset]   # Compresses each video to <name>_compressed.mp4
  $ video_compress_all -h                           # Show this help message
  $ video_compress_all                              # Same as -h

Arguments:
  [directory]   Directory containing videos (non-recursive). Default: current directory
  [crf]         Constant Rate Factor for video quality (lower = better, larger file).
                Typical range: 18–28. Default: 23
  [preset]      x264 speed/efficiency trade-off:
                ultrafast, superfast, veryfast, faster, fast, medium,
                slow, slower, veryslow. Default: slow

What it does:
  - Calls: video_compress <input> [crf] [preset] for each file
  - Targets common video files: mp4, mov, mkv, avi, m4v, webm (case-insensitive)
  - Skips files already named "*_compressed.mp4"
  - Skips when the target output already exists
EOF
    return 0
  fi

  local dir="${1:-.}"
  local crf="${2:-23}"
  local preset="${3:-slow}"

  # Preconditions
  if [ ! -d "$dir" ]; then
    echo "Error: directory '$dir' not found." >&2
    return 1
  fi
  if exists ! video_compress; then
    echo "Error: video_compress is not defined in this shell." >&2
    echo "Tip: load/define video_compress before running video_compress_all." >&2
    return 1
  fi

  local count=0 processed=0 skipped=0 failed=0

  for f in "$dir"/*; do
    [ -f "$f" ] || continue

    # Lowercase extension for matching
    local ext
    ext=$(printf '%s' "${f##*.}" | tr '[:upper:]' '[:lower:]')

    case "$ext" in
      mp4|mov|mkv|avi|m4v|webm) ;;
      *) continue ;;
    esac

    count=$((count + 1))

    local base output
    base="${f%.*}"

    # Skip files already compressed (ends with _compressed)
    case "$base" in
      *_compressed)
        echo "Skip (already compressed): $(basename "$f")"
        skipped=$((skipped + 1))
        continue
        ;;
    esac

    output="${base}_compressed.mp4"

    # Skip if target already exists
    if [ -f "$output" ]; then
      echo "Skip (output exists): $(basename "$output")"
      skipped=$((skipped + 1))
      continue
    fi

    echo "Compressing: $(basename "$f") → $(basename "$output")"
    if video_compress "$f" "$crf" "$preset"; then
      processed=$((processed + 1))
    else
      echo "Failed: $(basename "$f")" >&2
      failed=$((failed + 1))
    fi
  done

  if [ "$count" -eq 0 ]; then
    echo "No video files found in: $dir"
    return 0
  fi

  echo "— Summary —"
  echo "Found:     $count"
  echo "Processed: $processed"
  echo "Skipped:   $skipped"
  echo "Failed:    $failed"
}

function yt() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Download YouTube audio (MP3) or video (MP4) using yt-dlp.

Usage:
  $ yt <URL>           # Download best video+audio (MP4) [default]
  $ yt -l <URL>        # List available formats
  $ yt -a <URL>        # Download best audio only (MP3)
  $ yt -v <URL>        # Download best 1080p video+audio (MP4)
  $ yt -h              # Show this help message
  $ yt                 # Same as -h

Examples:
  $ yt https://youtu.be/dQw4w9WgXcQ
  $ yt -a https://youtu.be/dQw4w9WgXcQ
  $ yt -l https://youtu.be/dQw4w9WgXcQ

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
  $ zipper -c              # Zip the contents of each folder (excluding the folder itself)
  $ zipper -i              # Zip each folder (including the folder itself)
  $ zipper -h              # Show this help message
  $ zipper                 # Same as -h

Notes:
  - All .zip files in the current directory will be removed before zipping.
  - Output files will be named after each folder (e.g., folder.zip).
  - Only top-level directories are processed.
EOF
    return 0
  fi

  # Confirm before deleting existing zip files
  if compgen -G "*.zip" > /dev/null; then
    echo "Removing existing .zip files in the current directory..."
    rm -f ./*.zip
  fi

  case "$1" in
    "-c")
      for dir in */; do
        [ -d "$dir" ] || continue
        echo "Zipping contents of: $dir"
        (cd "$dir" && zip -r "../${dir%/}.zip" .)
      done
      ;;
    "-i")
      for dir in */; do
        [ -d "$dir" ] || continue
        echo "Zipping folder: $dir"
        zip -r "${dir%/}.zip" "$dir"
      done
      ;;
    "*")
      echo "Unknown option: $1"
      echo "Run 'zipper -h' for usage."
      return 1
      ;;
  esac
}
