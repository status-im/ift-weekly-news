#!/usr/bin/env bash
set -e

# Generate SUMMARY.md dynamically from reports directory

REPORTS_DIR="reports"
SUMMARY_FILE="$REPORTS_DIR/SUMMARY.md"

# Get all markdown files sorted in reverse chronological order (newest first)
mapfile -t files < <(find "$REPORTS_DIR" -name "*.markdown" -type f | sort -r)

# Start the SUMMARY.md file
cat > "$SUMMARY_FILE" << 'EOF'
# Summary

EOF

# Add the latest report as the landing page (first item, no section heading)
if [ ${#files[@]} -gt 0 ]; then
    latest_file="${files[0]}"
    filename=$(basename "$latest_file")
    title="${filename%.markdown}"
    echo "[$title](./$filename)" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
fi

# Add "Previous Reports" section with older reports
if [ ${#files[@]} -gt 1 ]; then
    echo "# Previous Reports" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    for i in $(seq 1 $((${#files[@]} - 1))); do
        file="${files[$i]}"
        filename=$(basename "$file")
        title="${filename%.markdown}"
        echo "- [$title](./$filename)" >> "$SUMMARY_FILE"
    done
    echo "" >> "$SUMMARY_FILE"
fi

# Add About section
cat >> "$SUMMARY_FILE" << 'EOF'
# About

[About IFT Weekly News](../README.md)
EOF

echo "✓ Generated $SUMMARY_FILE with ${#files[@]} report(s)"
