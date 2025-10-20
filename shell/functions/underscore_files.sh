function underscore_files() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
Rename all files in the specified folder by replacing spaces with underscores.

Usage:
  $ underscore_files /path/to/folder   # Rename files in the folder
  $ underscore_files -h                # Show this help message
  $ underscore_files                   # Same as -h

Notes:
  - Only regular files in the specified folder are processed.
  - Subdirectories and hidden files are ignored.
  - If no files need renaming, nothing will be changed.

Example
  $ underscore_files .                 # Rename files in the current directory
EOF
    return 0
  fi

  TARGET_DIR="$1"

  if [[ ! -d "$TARGET_DIR" ]]; then
    echo "🔴 Error: '$TARGET_DIR' is not a valid directory."
    return 1
  fi

  find "$TARGET_DIR" -type f -name "* *" -print0 | while IFS= read -r -d '' file; do
    base_name=$(basename "$file")
    new_name="${base_name// /_}"
    echo "🟡 Renaming: '$base_name' → '$new_name'"
    mv -- "$file" "$TARGET_DIR/$new_name"
  done
}
