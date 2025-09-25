function remove_quarantine() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
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
        && echo "🟢 Removed quarantine flag from: $file" \
        || echo "🔴 Failed to remove quarantine flag from: $file"
    else
      echo "🔴 Error: File not found '$file'"
    fi
  done
}
