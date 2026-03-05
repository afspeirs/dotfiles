copy_folder_to_subfolders() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
Copy a source folder into every immediate subdirectory of the target directory.

Usage:
  $ copy_folder_to_subfolders /path/source /path/target   # Copy source into each subfolder of target
  $ copy_folder_to_subfolders -h                          # Show this help message
  $ copy_folder_to_subfolders                             # Same as -h

Notes:
  - Only immediate subdirectories of the target directory are affected.
  - The entire source folder is copied into each subfolder.
  - If no subdirectories exist, nothing will be changed.

Example:
  $ copy_folder_to_subfolders ./assets ./projects
EOF
    return 0
  fi

  SOURCE_DIR="$1"
  TARGET_DIR="$2"

  if [ -z "$SOURCE_DIR" ] || [ -z "$TARGET_DIR" ]; then
    echo "🔴 Error: You must specify both a source folder and a target directory."
    echo "Run 'copy_folder_to_subfolders -h' for usage."
    return 1
  fi

  if [ ! -d "$SOURCE_DIR" ]; then
    echo "🔴 Error: Source folder '$SOURCE_DIR' does not exist."
    return 1
  fi

  if [ ! -d "$TARGET_DIR" ]; then
    echo "🔴 Error: Target directory '$TARGET_DIR' does not exist."
    return 1
  fi

  SUBFOLDERS=$(find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -type d)

  if [ -z "$SUBFOLDERS" ]; then
    echo "🟡 No subdirectories found inside '$TARGET_DIR'. Nothing to copy."
    return 0
  fi

  # Loop
  echo "$SUBFOLDERS" | while IFS= read -r dir; do
    echo "🟡 Copying '$SOURCE_DIR' → '$dir'"
    cp -r "$SOURCE_DIR" "$dir"
  done

  echo "🟢 Done!"
}
