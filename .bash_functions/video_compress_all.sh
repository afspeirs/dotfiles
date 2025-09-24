function video_compress_all() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
Batch-compress all videos in a directory using video_compress.

Usage:
  $ video_compress_all [directory] [crf] [preset]   # Compresses each video to <name>_compressed.mp4
  $ video_compress_all -h                           # Show this help message
  $ video_compress_all                              # Same as -h

Arguments:
  [directory]   # Directory containing videos (non-recursive). Default: current directory
  [crf]         # Constant Rate Factor for video quality (lower = better, larger file).
                  Typical range: 18-28. Default: 23
  [preset]      # x264 speed/efficiency trade-off:
                  ultrafast, superfast, veryfast, faster, fast, medium,
                  slow, slower, veryslow. Default: slow

What it does:
  - Calls: video_compress <input> [crf] [preset] for each file
  - Targets common video files: mp4, mov, mkv, avi, m4v, webm (case-insensitive)
  - Skips files already named "*_compressed.mp4"
  - Skips when the target output already exists
EOF
    return 0
  fi

  local dir="${1:-.}"
  local crf="${2:-23}"
  local preset="${3:-slow}"

  # Preconditions
  if [ ! -d "$dir" ]; then
    echo "🔴 Error: directory '$dir' not found." >&2
    return 1
  fi
  if exists ! video_compress; then
    echo "🔴 Error: video_compress is not defined." >&2
    return 1
  fi

  local count=0 processed=0 skipped=0 failed=0

  for f in "$dir"/*; do
    [ -f "$f" ] || continue

    # Lowercase extension for matching
    local ext
    ext=$(printf '%s' "${f##*.}" | tr '[:upper:]' '[:lower:]')

    case "$ext" in
      mp4|mov|mkv|avi|m4v|webm) ;;
      *) continue ;;
    esac

    count=$((count + 1))

    local base output
    base="${f%.*}"

    case "$base" in
      *_compressed)
        echo "🟡 Skip (already compressed): $(basename "$f")"
        skipped=$((skipped + 1))
        continue
        ;;
    esac

    output="${base}_compressed.mp4"

    if [ -f "$output" ]; then
      echo "🟡 Skip (output exists): $(basename "$output")"
      skipped=$((skipped + 1))
      continue
    fi

    if video_compress "$f" "$crf" "$preset"; then
      processed=$((processed + 1))
    else
      echo "🔴 Failed: $(basename "$f")" >&2
      failed=$((failed + 1))
    fi
  done

  if [ "$count" -eq 0 ]; then
    echo "🔴 Failed: No video files found in '$dir'"
    return 0
  fi

  echo "   — Summary —"
  echo "   Found:     $count"
  echo "   Processed: $processed"
  echo "   Skipped:   $skipped"
  echo "   Failed:    $failed"
}
