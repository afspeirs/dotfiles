function video_compress() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
Compress a video to H.264/AAC with sensible web-friendly defaults.

Usage:
  $ video_compress <input-file> [crf] [preset]   # Compress to <input>_compressed.mp4
  $ video_compress -h                            # Show this help message
  $ video_compress                               # Same as -h

Arguments:
  <input-file>    # Path to the source video (any format ffmpeg supports)
  [crf]           # Constant Rate Factor for video quality (lower = better, larger file)
                    Typical range: 18-28. Default: 23
  [preset]        # x264 speed/efficiency trade-off:
                    ultrafast, superfast, veryfast, faster, fast, medium,
                    slow, slower, veryslow. Default: slow

Output:
  Writes: <input_basename>_compressed.mp4
  Example: "Holiday Clip.mov" -> "Holiday Clip_compressed.mp4"

Notes:
  - Requires: ffmpeg (https://ffmpeg.org/)
  - Uses: H.264 (libx264), AAC 128k, -movflags +faststart, and won't overwrite (-n).

Examples:
  $ video_compress input.mp4
  $ video_compress "My Clip.mov" 21 veryslow
EOF
    return 0
  fi

  local input="$1"
  local crf="${2:-23}"
  local preset="${3:-slow}"
  local output="${input%.*}_compressed.mp4"

  if [[ ! -f "$input" ]]; then
    echo "🔴 Error: input file '$input' not found." >&2
    return 1
  fi
  if exists ! ffmpeg; then
    echo "🔴 Error: ffmpeg is not installed or not on PATH." >&2
    return 1
  fi

  echo "🟡 Compressing: $(basename "$input") → $(basename "$output")"
  if ffmpeg -hide_banner -loglevel error -n \
      -i "$input" \
      -vcodec libx264 -crf "$crf" -preset "$preset" \
      -acodec aac -b:a 128k \
      -movflags +faststart \
      "$output"
  then
    echo "🟢 Compressed video saved as: $output"
    return 0
  else
    local rc=$?
    echo "🔴 Error: ffmpeg failed (exit code $rc)." >&2
    return $rc
  fi
}
