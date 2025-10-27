 # IFT Weekly News

The repository build [https://news.free.technology](https://news.free.technology).

This repository supports **townhall preparation** by collecting relevant weekly updates.

## API Access

JSON API endpoints are available for programmatic access to reports.

**🔒 Authentication Required:** All API endpoints are protected by Keycloak authentication.

See [API.md](API.md) for full documentation including authentication examples.

- Weekly reports: `https://news.free.technology/api/weekly/`
- Monthly reports: `https://news.free.technology/api/monthly/`
- Latest: `https://news.free.technology/api/weekly/latest.json`

Data is automatically pulled from various sources and added to this repo via an **n8n pipeline**.

The pipeline runs **every Friday**, fetching all new data from the past week.

You can view the workflow [here](https://n8n.free.technology/workflow/ssJC5jcgiCQ5zFbM).

## Data Sources

The pipeline fetches data from four main sources:

### 1. Blogs
- [Status](https://status.app/blog/)
- [Nimbus](https://blog.nimbus.team/)
- [Codex](https://blog.codex.storage/)
- [Nomos](https://blog.nomos.tech/)
- [Keycard](https://keycard.tech/blog/)
- [Logos](https://press.logos.co/search?type=article)

### 2. YouTube Videos
- Channels: `hio`, `logos`, `thebtcpodcast`

### 3. Project Releases
- Fetches all **non-draft releases** from different projects.

### 4. Forum Posts
- Forums: `Logos`, `VAC`, `Status`
