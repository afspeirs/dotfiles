function loop_files() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
Loop over an array of filenames and create a folder for each.

Usage:
  $ loop_files file1 file2 ...      # Creates a folder for each filename
  $ loop_files -h                   # Show this help message

Example:
  $ loop_files page-1.hbs page-2.hbs
EOF
    return 0
  fi

  # All arguments become the array
  local filenames=("$@")

  for element in "${filenames[@]}"; do
    mkdir -p "$element"
    echo "🟢 Created: $element"
  done
}
