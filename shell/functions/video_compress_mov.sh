function video_compress_mov() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    cat <<'EOF'
Compress a video, supporting **alpha channel (transparency)**.
This uses the **ProRes 4444** codec within a **.mov** container.

Usage:
  $ video_compress <input-file> [qscale] [preset] # Compress to <input>_compressed.mov
  $ video_compress -h                            # Show this help message
  $ video_compress                               # Same as -h

Arguments:
  <input-file>    # Path to the source video (must have an alpha channel)
  [qscale]        # Quality factor for ProRes (lower = better/larger file). Range: 1-10. Default: 5
  [preset]        # x264/ProRes speed/efficiency trade-off (Default: default)

Output:
  Writes: <input_basename>_compressed.mov

Notes:
  - Requires: ffmpeg (https://ffmpeg.org/)
  - Uses: ProRes 4444 (prores_ks) for alpha channel support.

Examples:
  $ video_compress input_alpha.mov
  $ video_compress "My Clip.mov" 3
EOF
    return 0
  fi

  local input="$1"
  local qscale="${2:-5}"
  local preset="${3:-default}"
  local output="${input%.*}_compressed.mov"

  if [[ ! -f "$input" ]]; then
    echo "🔴 Error: input file '$input' not found." >&2
    return 1
  fi
  if ! command -v ffmpeg &> /dev/null; then
    echo "🔴 Error: ffmpeg is not installed or not on PATH." >&2
    return 1
  fi

  echo "🟡 Compressing with Alpha (ProRes 4444): $(basename "$input") → $(basename "$output")"
  # ---------------------------------
  # REMOVED THE EMBOLDENING ASTERISKS
  # ---------------------------------
  if ffmpeg -hide_banner -loglevel error -n \
      -i "$input" \
      -c:v prores_ks \
      -profile:v 4444 \
      -pix_fmt yuva444p16le \
      -qscale:v "$qscale" \
      -preset:v "$preset" \
      -c:a copy \
      -movflags +faststart \
      "$output"
  then
    echo "🟢 Compressed video with alpha channel saved as: $output"
    return 0
  else
    local rc=$?
    echo "🔴 Error: ffmpeg failed (exit code $rc). Check if your source file has an alpha channel." >&2
    return $rc
  fi
}
