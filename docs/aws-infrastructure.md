# AWS Infrastructure

> This page is intentionally sanitized. Real account identifiers, bucket names, hosted zone IDs, distribution IDs, instance IDs, IPs, and usernames are not published.

## Regional Layout

- Primary application region: `ap-northeast-2` pattern in the private deployment
- ACM for CloudFront is expected in `us-east-1`
- Public examples use placeholders such as `<aws-account-id>` and `<cloudfront-distribution-id>`

## Core Components

### Frontend delivery

- S3 bucket: `<s3-frontend-bucket>`
- CloudFront distribution: `<cloudfront-distribution-id>`
- Route53 records for `<app-domain>` and `www.<app-domain>`
- SPA fallback enabled through CloudFront behavior / error mapping

### API runtime

- EC2 instance: `<ec2-instance-id>`
- Public DNS: `<api-domain>`
- Reverse proxy: Caddy
- Runtime: backend container + private PostgreSQL container

### Database backups

- Backup bucket: `<backup-bucket>`
- Separate from frontend artifact storage
- Intended for dumps, compressed archives, and future restore validation runs

### Optional helper service

- Lambda-based upload helper for PPT/PPTX format intake
- Private storage for uploaded source files
- SES-backed notification pattern for operational workflows

## Network And Exposure Model

- Public ports limited to HTTP/HTTPS and tightly controlled SSH
- PostgreSQL is not publicly exposed
- API is reached through the reverse proxy rather than direct container access
- Static content is delivered from CDN edge rather than from the VM

## IAM Posture

- Deploy identity should be least-privilege
- Frontend CD requires S3 object management and CloudFront invalidation only
- VM access should use a dedicated low-scope deploy user over SSH
- Break-glass or human-admin access should be separated from automation identities

## Why This Design Works Well In A Portfolio

- It is concrete enough to show production thinking
- It is small enough to be understandable in an interview
- It shows a clear maturity path toward RDS, better observability, and stronger automation

## Related Assets

- Terraform skeleton: [`../infra/terraform-skeleton/`](../infra/terraform-skeleton/)
- Caddy example: [`../infra/caddy.example`](../infra/caddy.example)
- Docker Compose example: [`../infra/docker-compose.example.yml`](../infra/docker-compose.example.yml)
