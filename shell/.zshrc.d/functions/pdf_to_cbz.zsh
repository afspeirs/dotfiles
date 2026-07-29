function pdf_to_cbz() {
  if [ "$1" = "-h" ] || [ -z "$1" ]; then
    cat <<'EOF'
Convert PDFs to CBZ

Usage:
  $ pdf_to_cbz [path]      # Recursively convert PDF chapters
  $ pdf_to_cbz .           # Convert in current directory
EOF
    return 0
  fi

  if ! command -v pdftoppm &> /dev/null || ! command -v zip &> /dev/null; then
    echo "🔴 Error: Install poppler-utils and zip first."
    return 1
  fi

  find "$1" -type f -name "*.pdf" | while read -r pdf_file; do
    dir=$(dirname "$pdf_file")
    base=$(basename "$pdf_file" .pdf)

    echo "📖 Converting Chapter: $base"

    pushd "$dir" > /dev/null

    # Extract images
    pdftoppm -jpeg -r 200 "$base.pdf" "page"

    # Create CBZ
    zip -q -m "$base.cbz" page-*.jpg

    # Optional: Delete the PDF after successful conversion
    # rm "$base.pdf"

    popd > /dev/null
    echo "✅ Done: $base.cbz"
  done
}
