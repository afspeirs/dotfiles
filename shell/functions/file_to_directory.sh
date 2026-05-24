function file_to_directory() {
  if [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]]; then
    cat <<'EOF'
Create a folder for each file (named after the file, minus extension) and move the file into it.

Usage:
  $ file_to_dir           # Process all files in the current directory
  $ file_to_dir -h        # Show this help message

Examples:
  $ file_to_dir
  # Result: 'report.pdf' moves into a new folder named 'report/'

Notes:
  - If multiple files have the same name but different extensions (e.g., image.jpg and image.png),
    they will both be moved into the same 'image/' folder.
  - Hidden files and directories are ignored.
EOF
    return 0
  fi

  local filename
  local dirname

  for filename in *; do
    # Only process regular files
    if [[ -f "$filename" ]]; then
      # Extract name without extension (e.g., "photo.jpg" -> "photo")
      dirname="${filename%.*}"

      # Handle cases where the file has no extension
      if [[ -z "$dirname" ]]; then
        dirname="$filename"
      fi

      # Create the directory if it doesn't exist
      mkdir -p -- "$dirname"

      # Move the file into the directory
      mv -- "$filename" "$dirname/"
    fi
  done
}
