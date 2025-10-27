# IFT Weekly News API

The IFT Weekly News site provides JSON API endpoints for programmatic access to reports.

## 🔒 Authentication

**All API endpoints require authentication via Keycloak.**

The API inherits the same authentication layer as the main site. You must:
1. Authenticate with Keycloak (OAuth/OIDC)
2. Obtain an access token
3. Include the token in your API requests

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
// First, obtain a Keycloak token
const getToken = async () => {
  const response = await fetch('https://your-keycloak-domain/auth/realms/your-realm/protocol/openid-connect/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      client_id: 'your-client-id',
      client_secret: 'your-client-secret',
      grant_type: 'client_credentials'
    })
  });
  const data = await response.json();
  return data.access_token;
};

// Get latest weekly report with authentication
const token = await getToken();
const response = await fetch('https://news.free.technology/api/weekly/latest.json', {
  headers: { 'Authorization': `Bearer ${token}` }
});
const data = await response.json();
console.log(`Latest report: ${data.date}`);
console.log(data.content);
```

### Python

```python
import requests

# First, obtain a Keycloak token
token_response = requests.post(
    'https://your-keycloak-domain/auth/realms/your-realm/protocol/openid-connect/token',
    data={
        'client_id': 'your-client-id',
        'client_secret': 'your-client-secret',
        'grant_type': 'client_credentials'
    }
)
token = token_response.json()['access_token']

# Get list of all weekly reports with authentication
headers = {'Authorization': f'Bearer {token}'}
response = requests.get('https://news.free.technology/api/weekly/index.json', headers=headers)
data = response.json()

print(f"Total weekly reports: {data['count']}")
for report in data['reports']:
    print(f"- {report['date']}: {report['url']}")
```

### curl (with authentication)

```bash
# First, obtain a Keycloak token
TOKEN=$(curl -X POST "https://your-keycloak-domain/auth/realms/your-realm/protocol/openid-connect/token" \
  -d "client_id=your-client-id" \
  -d "client_secret=your-client-secret" \
  -d "grant_type=client_credentials" \
  | jq -r .access_token)

# Get latest weekly report
curl -H "Authorization: Bearer $TOKEN" \
  https://news.free.technology/api/weekly/latest.json | jq .

# Get specific monthly report
curl -H "Authorization: Bearer $TOKEN" \
  https://news.free.technology/api/monthly/2025-09.json | jq .content -r
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
- **Authentication required** - All endpoints are protected by Keycloak authentication
- You must obtain and include a valid access token in your requests
- Access is controlled by the same Keycloak realm as the main site

---

## Support

For issues or questions, please visit the [repository](https://github.com/status-im/ift-weekly-news).
