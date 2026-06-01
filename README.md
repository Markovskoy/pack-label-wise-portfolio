# PackLabel / LabelMaster Portfolio Case Study

> Production-deployed logistics labeling platform documented as a sanitized DevOps/SRE portfolio project.

[![Status](https://img.shields.io/badge/status-sanitized%20case%20study-355CFF)](#disclaimer)
[![Frontend](https://img.shields.io/badge/frontend-React%2018%20%2B%20Vite-1F2A44)](#architecture-overview)
[![Runtime](https://img.shields.io/badge/runtime-EC2%20%2B%20Docker%20Compose-355CFF)](#aws-infrastructure)
[![Database](https://img.shields.io/badge/database-PostgreSQL%2016-FF9F1A)](#database-and-backup-strategy)
[![Delivery](https://img.shields.io/badge/delivery-S3%20%2B%20CloudFront-1F2A44)](#ci-cd-release-flow)

PackLabel / LabelMaster is a production-deployed logistics labeling web platform built to import product data from Excel, manage shipments, generate pallet/box layouts, and export shipping labels to PDF/PPTX. This public repository is a sanitized engineering case study focused on AWS deployment, CI/CD, PostgreSQL operations, and SRE practices. Proprietary application code is intentionally not included.

![Architecture](docs/assets/architecture-diagram.png)

## Hero / Project Summary

- Private commercial product with public-safe portfolio documentation
- Focused on platform delivery, release engineering, AWS operations, and production boundaries
- Built around a React 18 + TypeScript + Vite frontend, EC2-hosted backend runtime, PostgreSQL 16, and AWS edge delivery
- Intended for recruiters, hiring managers, and DevOps/SRE portfolio review

## What The Product Does

- Imports product and shipment data from Excel
- Manages products, shipments, suppliers, and label-related workflows
- Calculates pallet and box arrangements
- Exports labels to PDF and PPTX
- Supports JWT-based authenticated access
- Runs as a real deployed business workflow rather than a toy demo

## Why This Project Is Relevant For DevOps/SRE

- Static frontend delivery through S3 + CloudFront with cache-aware deploy logic
- Backend runtime isolated on EC2 behind Caddy with TLS termination
- PostgreSQL 16 runs privately in Docker with persistent volume storage
- Release process is intentionally separated from feature branch work
- Database migrations are treated as a controlled deployment stage
- Infrastructure choices are documented with scaling and migration paths
- Operational roadmap includes observability, restore testing, rollback, and cost controls

## Architecture Overview

- Public web traffic: Route53 -> CloudFront -> S3 frontend
- API traffic: Route53 -> EC2 -> Caddy -> backend container
- Data plane: backend container -> private PostgreSQL container
- Optional async helper flow: frontend -> Lambda upload endpoint -> private S3 -> SES notification
- Frontend stack validated from the codebase: React 18, TypeScript, Vite, Tailwind, shadcn/Radix UI, TanStack Query

More detail: [docs/architecture.md](docs/architecture.md)

## AWS Infrastructure

- Region pattern documented with placeholders only
- S3 bucket for frontend artifacts
- CloudFront distribution for CDN and SPA fallback
- Route53 DNS for apex, `www`, and API subdomain routing
- EC2 host for backend runtime, Caddy reverse proxy, and PostgreSQL container
- Separate backup bucket concept for database dumps/snapshots
- Least-privilege deploy IAM policy example included

More detail: [docs/aws-infrastructure.md](docs/aws-infrastructure.md)

## CI/CD Release Flow

- Feature branches do not trigger production deploys
- Pushes to release branches do not deploy by themselves
- Merging `release/vX.Y.Z` into `main` triggers release CD
- Manual `workflow_dispatch` supports selective frontend, backend, and migration stages
- Frontend build artifacts are versioned
- CloudFront invalidation is included in the deploy sequence
- Backend deploy concept uses SSH hook + Docker Compose on EC2

Sanitized workflow: [`.github/workflows/release.example.yml`](.github/workflows/release.example.yml)

## Database And Backup Strategy

- PostgreSQL 16 deployed in Docker with persistent host-mounted storage
- Database port is not exposed publicly
- Controlled migration stage separated from app deploy
- Backup strategy documented with object storage separation and restore-test roadmap
- Growth path documented: move to RDS when scale and operational overhead justify it

More detail: [docs/database.md](docs/database.md)

## Security Model

- No secrets published in this repository
- No real AWS account IDs, zone IDs, distribution IDs, instance IDs, IPs, usernames, or bucket names are used in examples
- Public repo contains sanitized placeholders only
- JWT-based authentication boundary documented at a high level
- TLS on frontend and API endpoints
- Recommendation set includes auth endpoint rate limiting, least privilege, and backup isolation

More detail: [docs/security.md](docs/security.md)

## SRE / Operability

- Rollback concept for frontend and backend
- Health check and smoke check expectations
- Monitoring and alerting plan
- Backup restore validation plan
- Cost-control guidance with AWS Budgets and tagging
- Incident response checklist included

More detail: [docs/sre-operability.md](docs/sre-operability.md)

## Screenshots / Demo

- Public-safe visual overview: [docs/screenshots.md](docs/screenshots.md)
- Screenshot assets are either redacted or mock visuals
- The design language follows the original product palette: deep navy, electric blue, and accent orange

## Sanitized Examples

- Terraform skeleton: [`infra/terraform-skeleton/`](infra/terraform-skeleton/)
- Release workflow example: [`.github/workflows/release.example.yml`](.github/workflows/release.example.yml)
- Docker Compose example: [`infra/docker-compose.example.yml`](infra/docker-compose.example.yml)
- Caddy example: [`infra/caddy.example`](infra/caddy.example)
- Sample migration: [`db/migrations-sample/001_init_schema_sample.sql`](db/migrations-sample/001_init_schema_sample.sql)

## Roadmap

- Add production-safe monitoring stack examples
- Add synthetic checks and uptime probes
- Add restore-test automation example for PostgreSQL backups
- Add RDS migration decision record when the system outgrows single-host Postgres
- Add cost dashboards and SLO reporting examples

More detail: [docs/roadmap.md](docs/roadmap.md)

## Disclaimer

- This repository is a portfolio / case-study repository, not the private product source.
- Production code remains private.
- All examples are sanitized.
- Some implementation details are intentionally generalized or omitted to avoid exposing proprietary logic or operational identifiers.
- Application code for the product itself is intentionally excluded; the emphasis here is infrastructure, deployment, and operational engineering.

## LinkedIn Project Description

Built and deployed a production-like logistics labeling platform on AWS. The system imports product data from Excel, manages shipments and pallet/box layouts, and exports shipping labels to PDF/PPTX. My main focus was the DevOps/SRE side: S3 + CloudFront static delivery, EC2 + Docker Compose runtime, Caddy reverse proxy, PostgreSQL operations, GitHub Actions release flow, controlled DB migrations, TLS/domain setup, and secure deployment practices. Application code was AI-assisted, while infrastructure, deployment, CI/CD and operational hardening were designed and implemented by me.

## Publish Notes

- GitHub Pages can be served from `docs/` directly or built with MkDocs using `mkdocs.yml`.
- Start at [docs/index.md](docs/index.md) for the documentation home page.
- See [PUBLISHING.md](PUBLISHING.md) for the final publication and LinkedIn checklist.
