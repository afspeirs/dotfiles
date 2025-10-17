function yt() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
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

  if exists ! yt-dlp; then
    echo "🔴 Error: yt-dlp is not installed. Please install it."
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
