function each_folder() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<EOF
Run a command in each subfolder of the current directory.

Usage:
  $ each_folder <command> [args...]   # Run a command in each subfolder
  $ each_folder -h                    # Show this help message
  $ each_folder                       # Same as -h

Example:
  $ each_folder ls -la       # Lists contents of each subfolder in long format

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
