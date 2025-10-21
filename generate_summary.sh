#!/usr/bin/env bash
set -e

# Generate SUMMARY.md dynamically from reports directory

REPORTS_DIR="reports"
SUMMARY_FILE="$REPORTS_DIR/SUMMARY.md"

# Start the SUMMARY.md file
cat > "$SUMMARY_FILE" << 'EOF'
# Summary

[Introduction](../README.md)

# Weekly Reports

EOF

# Find all .markdown files, sort them in reverse chronological order (newest first)
# Extract date from filename (assumes format: YYYY-MM-DD.markdown)
find "$REPORTS_DIR" -name "*.markdown" -type f | sort -r | while read -r file; do
    filename=$(basename "$file")
    # Extract the date part (YYYY-MM-DD) as the title
    title="${filename%.markdown}"
    echo "- [$title](./$filename)" >> "$SUMMARY_FILE"
done

echo "✓ Generated $SUMMARY_FILE with $(grep -c "^\- \[" "$SUMMARY_FILE" || echo 0) reports"
