# IFT Weekly News API

The IFT Weekly News site provides JSON API endpoints for programmatic access to reports.

## 🌐 Public Access

**All API endpoints are publicly accessible.** No authentication required.

## Base URL

```
https://news.free.technology/api/
```

## Endpoints

### Main API Index

Get information about all available endpoints:

```
GET https://news.free.technology/api/index.json
```

**Response:**
```json
{
  "version": "1.0",
  "endpoints": {
    "weekly": {
      "latest": "https://news.free.technology/api/weekly/latest.json",
      "list": "https://news.free.technology/api/weekly/index.json",
      "count": 2
    },
    "monthly": {
      "latest": "https://news.free.technology/api/monthly/latest.json",
      "list": "https://news.free.technology/api/monthly/index.json",
      "count": 3
    }
  },
  "documentation": "https://news.free.technology/",
  "generated_at": "2025-10-23T14:30:00Z"
}
```

---

### Weekly Reports

#### Get Latest Weekly Report

```
GET https://news.free.technology/api/weekly/latest.json
```

**Response:**
```json
{
  "date": "2025-10-24",
  "type": "weekly",
  "content": "**2025-10-24 WEEKLY REPORT**\n- ### Blog Posts\n...",
  "url": "https://news.free.technology/weekly/2025-10-24.html",
  "generated_at": "2025-10-23T14:30:00Z"
}
```

#### Get Specific Weekly Report

```
GET https://news.free.technology/api/weekly/{YYYY-MM-DD}.json
```

Example:
```
GET https://news.free.technology/api/weekly/2025-10-23.json
```

#### List All Weekly Reports

```
GET https://news.free.technology/api/weekly/index.json
```

**Response:**
```json
{
  "reports": [
    {
      "date": "2025-10-24",
      "url": "https://news.free.technology/weekly/2025-10-24.html",
      "api": "https://news.free.technology/api/weekly/2025-10-24.json"
    },
    {
      "date": "2025-10-23",
      "url": "https://news.free.technology/weekly/2025-10-23.html",
      "api": "https://news.free.technology/api/weekly/2025-10-23.json"
    }
  ],
  "count": 2,
  "type": "weekly"
}
```

---

### Monthly Reports

#### Get Latest Monthly Report

```
GET https://news.free.technology/api/monthly/latest.json
```

**Response:**
```json
{
  "date": "2025-09",
  "type": "monthly",
  "content": "**SEPTEMBER 2025 MONTHLY REPORT**\n...",
  "url": "https://news.free.technology/monthly/2025-09.html",
  "generated_at": "2025-10-23T14:30:00Z"
}
```

#### Get Specific Monthly Report

```
GET https://news.free.technology/api/monthly/{YYYY-MM}.json
```

Example:
```
GET https://news.free.technology/api/monthly/2025-09.json
```

#### List All Monthly Reports

```
GET https://news.free.technology/api/monthly/index.json
```

**Response:**
```json
{
  "reports": [
    {
      "date": "2025-09",
      "url": "https://news.free.technology/monthly/2025-09.html",
      "api": "https://news.free.technology/api/monthly/2025-09.json"
    },
    {
      "date": "2025-08",
      "url": "https://news.free.technology/monthly/2025-08.html",
      "api": "https://news.free.technology/api/monthly/2025-08.json"
    }
  ],
  "count": 3,
  "type": "monthly"
}
```

---

## Usage Examples

### JavaScript/Node.js

```javascript
// Get latest weekly report
const response = await fetch('https://news.free.technology/api/weekly/latest.json');
const data = await response.json();
console.log(`Latest report: ${data.date}`);
console.log(data.content);
```

### Python

```python
import requests

# Get list of all weekly reports
response = requests.get('https://news.free.technology/api/weekly/index.json')
data = response.json()

print(f"Total weekly reports: {data['count']}")
for report in data['reports']:
    print(f"- {report['date']}: {report['url']}")
```

### curl

```bash
# Get latest weekly report
curl https://news.free.technology/api/weekly/latest.json | jq .

# Get specific monthly report
curl https://news.free.technology/api/monthly/2025-09.json | jq .content -r

# Get list of all reports
curl https://news.free.technology/api/weekly/index.json | jq .
```

---

## Response Format

All endpoints return JSON with CORS enabled and proper `Content-Type: application/json` headers (when served via GitHub Pages).

### Field Descriptions

- **`date`**: Report date in `YYYY-MM-DD` (weekly) or `YYYY-MM` (monthly) format
- **`type`**: Either `"weekly"` or `"monthly"`
- **`content`**: Full markdown content of the report
- **`url`**: Human-readable HTML page URL
- **`api`**: JSON API endpoint URL
- **`generated_at`**: ISO 8601 timestamp of when the API was last generated
- **`count`**: Number of reports available

---

## Notes

- API endpoints are **static JSON files** generated during the build process
- Updates occur automatically when new reports are published (typically every Friday via n8n)
- **No authentication required** - All endpoints are publicly accessible

---

## Support

For issues or questions, please visit the [repository](https://github.com/status-im/ift-weekly-news).
