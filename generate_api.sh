#!/usr/bin/env bash
set -e

# Generate JSON API endpoints from markdown reports

REPORTS_DIR="reports"
API_DIR="book/api"
WEEKLY_DIR="$REPORTS_DIR/weekly"
MONTHLY_DIR="$REPORTS_DIR/monthly"
API_WEEKLY_DIR="$API_DIR/weekly"
API_MONTHLY_DIR="$API_DIR/monthly"

mkdir -p "$API_WEEKLY_DIR"
mkdir -p "$API_MONTHLY_DIR"

# Function to convert markdown to JSON
markdown_to_json() {
    local file="$1"
    local date=$(basename "$file" .markdown)
    local content=$(cat "$file")

    # Escape JSON special characters
    content=$(echo "$content" | jq -Rs .)

    # Create JSON object
    cat <<EOF
{
  "date": "$date",
  "type": "$(basename $(dirname "$file"))",
  "content": $content,
  "url": "https://news.free.technology/$(basename $(dirname "$file"))/$date.html",
  "generated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
}

# Process weekly reports
echo "Generating weekly report APIs..."
weekly_files=($(find "$WEEKLY_DIR" -name "*.markdown" -type f 2>/dev/null | sort -r || true))
weekly_list="[]"

if [ ${#weekly_files[@]} -gt 0 ]; then
    # Generate individual report JSONs
    for file in "${weekly_files[@]}"; do
        filename=$(basename "$file" .markdown)
        markdown_to_json "$file" > "$API_WEEKLY_DIR/${filename}.json"
        echo " Created $API_WEEKLY_DIR/${filename}.json"
    done

    # Create latest.json (most recent weekly report)
    latest_weekly="${weekly_files[0]}"
    markdown_to_json "$latest_weekly" > "$API_WEEKLY_DIR/latest.json"
    echo " Created $API_WEEKLY_DIR/latest.json"

    # Create index.json (list of all weekly reports)
    weekly_list=$(jq -n --argjson files "$(
        for file in "${weekly_files[@]}"; do
            filename=$(basename "$file" .markdown)
            echo "{\"date\":\"$filename\",\"url\":\"https://news.free.technology/weekly/$filename.html\",\"api\":\"https://news.free.technology/api/weekly/$filename.json\"}"
        done | jq -s .
    )" '$files')

    echo "$weekly_list" | jq '{reports: ., count: length, type: "weekly"}' > "$API_WEEKLY_DIR/index.json"
    echo " Created $API_WEEKLY_DIR/index.json"
fi

# Process monthly reports
echo "Generating monthly report APIs..."
monthly_files=($(find "$MONTHLY_DIR" -name "*.markdown" -type f 2>/dev/null | sort -r || true))
monthly_list="[]"

if [ ${#monthly_files[@]} -gt 0 ]; then
    # Generate individual report JSONs
    for file in "${monthly_files[@]}"; do
        filename=$(basename "$file" .markdown)
        markdown_to_json "$file" > "$API_MONTHLY_DIR/${filename}.json"
        echo " Created $API_MONTHLY_DIR/${filename}.json"
    done

    # Create latest.json (most recent monthly report)
    latest_monthly="${monthly_files[0]}"
    markdown_to_json "$latest_monthly" > "$API_MONTHLY_DIR/latest.json"
    echo " Created $API_MONTHLY_DIR/latest.json"

    # Create index.json (list of all monthly reports)
    monthly_list=$(jq -n --argjson files "$(
        for file in "${monthly_files[@]}"; do
            filename=$(basename "$file" .markdown)
            echo "{\"date\":\"$filename\",\"url\":\"https://news.free.technology/monthly/$filename.html\",\"api\":\"https://news.free.technology/api/monthly/$filename.json\"}"
        done | jq -s .
    )" '$files')

    echo "$monthly_list" | jq '{reports: ., count: length, type: "monthly"}' > "$API_MONTHLY_DIR/index.json"
    echo " Created $API_MONTHLY_DIR/index.json"
fi

# Create main API index
cat > "$API_DIR/index.json" <<EOF
{
  "version": "1.0",
  "endpoints": {
    "weekly": {
      "latest": "https://news.free.technology/api/weekly/latest.json",
      "list": "https://news.free.technology/api/weekly/index.json",
      "count": ${#weekly_files[@]}
    },
    "monthly": {
      "latest": "https://news.free.technology/api/monthly/latest.json",
      "list": "https://news.free.technology/api/monthly/index.json",
      "count": ${#monthly_files[@]}
    }
  },
  "documentation": "https://news.free.technology/",
  "generated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

echo " Created $API_DIR/index.json"
echo ""
echo " API generation complete!"
