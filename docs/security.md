# Security

## Security Principles

- No secrets in the public repository
- No public PostgreSQL access
- Least-privilege automation identities
- Separate operational layers for CDN, API runtime, and database
- Sanitized infrastructure examples only

## Runtime Security Model

- Frontend is delivered from S3 + CloudFront over TLS
- API traffic is terminated over TLS by Caddy
- PostgreSQL listens only on private/local runtime paths and is not Internet-exposed
- Backend and database run in containers with scoped volumes and environment configuration

## Authentication

- JWT-based application authentication
- Private backend handles auth boundaries
- Email verification is designed around SES-backed code delivery
- Verification codes should be short-lived, single-use, and stored as hashes rather than plaintext

## Hardening Recommendations

- Rate-limit auth and email verification endpoints by IP, account, and device fingerprint
- Restrict SSH to approved admin/deploy IP ranges where possible
- Use a dedicated deploy user with only the permissions required for release automation
- Store GitHub Actions secrets outside the repository and rotate them regularly
- Keep backup storage separate from primary application artifact storage

## Public Repo Safety Controls

- Real account IDs removed
- Real bucket names removed
- Real Route53 zone IDs removed
- Real CloudFront distribution IDs removed
- Real EC2 instance IDs and Elastic IPs removed
- Real security group IDs removed
- Real deploy usernames removed
- Real Lambda URLs removed
- Real customer data and dumps omitted

## What This Repo Intentionally Does Not Reveal

- Proprietary backend implementation
- Exact production topology details beyond conceptual design
- Secrets, keys, tokens, credentials, or private runbook procedures
