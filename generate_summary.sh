#!/usr/bin/env bash
set -e

# Generate SUMMARY.md dynamically from reports directory

REPORTS_DIR="reports"
SUMMARY_FILE="$REPORTS_DIR/SUMMARY.md"
WEEKLY_DIR="$REPORTS_DIR/weekly"
MONTHLY_DIR="$REPORTS_DIR/monthly"

# Copy README.md into reports folder for About page
cp README.md "$REPORTS_DIR/About.md"

# Get all weekly and monthly reports sorted in reverse chronological order (newest first)
mapfile -t weekly_files < <(find "$WEEKLY_DIR" -name "*.markdown" -type f 2>/dev/null | sort -r || true)
mapfile -t monthly_files < <(find "$MONTHLY_DIR" -name "*.markdown" -type f 2>/dev/null | sort -r || true)

# Start the SUMMARY.md file
cat > "$SUMMARY_FILE" << 'EOF'
# Summary

EOF

# Add the latest weekly report as the landing page
if [ ${#weekly_files[@]} -gt 0 ]; then
    latest_file="${weekly_files[0]}"
    filename=$(basename "$latest_file")
    title="${filename%.markdown}"
    # Use relative path from reports dir
    relative_path="./weekly/$filename"
    echo "[$title]($relative_path)" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
fi

# Add "Weekly Reports" section with ALL weekly reports
if [ ${#weekly_files[@]} -gt 0 ]; then
    echo "# Weekly Reports" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    for file in "${weekly_files[@]}"; do
        filename=$(basename "$file")
        title="${filename%.markdown}"
        echo "- [$title](./weekly/$filename)" >> "$SUMMARY_FILE"
    done
    echo "" >> "$SUMMARY_FILE"
fi

# Add "Monthly Reports" section
if [ ${#monthly_files[@]} -gt 0 ]; then
    echo "# Monthly Reports" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    for file in "${monthly_files[@]}"; do
        filename=$(basename "$file")
        title="${filename%.markdown}"
        echo "- [$title](./monthly/$filename)" >> "$SUMMARY_FILE"
    done
    echo "" >> "$SUMMARY_FILE"
fi

# Add About section
echo "---" >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"
echo "[About](./About.md)" >> "$SUMMARY_FILE"

echo "✓ Generated $SUMMARY_FILE with ${#weekly_files[@]} weekly and ${#monthly_files[@]} monthly report(s)"
