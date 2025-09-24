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
    echo "🔴 Removing existing .zip files in the current directory..."
    rm -f ./*.zip
  fi

  case "$1" in
    "-c")
      for dir in */; do
        [ -d "$dir" ] || continue
        echo "🟡 Zipping contents of: $dir"
        (cd "$dir" && zip -r "../${dir%/}.zip" .)
      done
      ;;
    "-i")
      for dir in */; do
        [ -d "$dir" ] || continue
        echo "🟡 Zipping folder: $dir"
        zip -r "${dir%/}.zip" "$dir"
      done
      ;;
    *)
      echo "🔴 Unknown option: $1"
      echo "   Run 'zipper -h' for usage."
      return 1
      ;;
  esac
}
