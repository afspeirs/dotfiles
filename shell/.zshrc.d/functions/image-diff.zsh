function image-diff() {
  if [ "$#" -lt 2 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
Compare two images side-by-side using timg.

Usage:
  $ image-diff <file1> <file2>  # Compare two images
  $ image-diff -h               # Show this help message

Example:
  $ image-diff old.png new.png
  $ git difftool -t imagediff -- "*.png"

Note:
  In tmux, opens a new pane (click to render).
  Outside tmux, renders inline.
EOF
    return 0
  fi

  local LOCAL="$1"
  local REMOTE="$2"

  if [[ ! -f "$LOCAL" ]]; then
    echo "🔴 Error: File not found: $LOCAL"
    return 1
  fi

  if [[ ! -f "$REMOTE" ]]; then
    echo "🔴 Error: File not found: $REMOTE"
    return 1
  fi

  if [[ -n "$TMUX" ]]; then
    local TEMP_LOCAL=$(mktemp)
    cp "$LOCAL" "$TEMP_LOCAL"

    local cmd
    printf -v cmd 'timg -pk --grid=2x1 %q %q; rm %q; read -n1 -p "Press any key..."' "$TEMP_LOCAL" "$REMOTE" "$TEMP_LOCAL"
    tmux split-window -h bash -c "$cmd"
  else
    timg -pk --grid=2x1 "$LOCAL" "$REMOTE"
  fi
}
