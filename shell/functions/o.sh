function o() {
  if [ "$1" = "-h" ]; then
    cat <<'EOF'
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
    (dolphin "$target" > /dev/null 2>&1 &)
  elif exists explorer.exe; then
    explorer.exe "$target"
  elif exists open; then
    open "$target"
  else
    echo "🔴 Error: No supported file explorer found. Please open '$target' manually."
    return 1
  fi
}
