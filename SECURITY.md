# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |
| < 0.1   | :x:                |

## Reporting a Vulnerability

To report a security vulnerability, please use the [GitHub Security Advisory "Report a Vulnerability" tab](../../security/advisories/new).

Please include:
- A description of the vulnerability
- Steps to reproduce the issue
- Potential impact
- Suggested fix (if any)

We will acknowledge receipt within 48 hours and provide a detailed response within 7 days.

## Security Best Practices

When using skills in this repository:

- **Never commit API tokens** — Use environment variables (`CLICKUP_TOKEN`)
- **Validate API responses** — Check HTTP status codes before processing
- **Respect rate limits** — Implement backoff when receiving HTTP 429
- **Use HTTPS only** — All API calls should use `https://` endpoints
