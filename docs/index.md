# LabelMaster / Potaglab — AWS DevOps Case Study

LabelMaster / Potaglab is a private logistics labeling application deployed on AWS. The platform handles a practical business workflow: importing product data from Excel, managing shipments, and generating labels for export in PDF or PPTX.

This public repository is a sanitized DevOps / SRE case study. Production code, secrets, customer data, account identifiers, and real operational names are intentionally not included. The focus here is the delivery and operations layer around the product: infrastructure shape, release flow, database handling, backups, security posture, and day-to-day operability.

The production-facing website is available at [potaglab.com](https://potaglab.com). This repository documents the platform around that deployment rather than mirroring the proprietary application code.

## Architecture

The platform uses a simple and readable production layout. Public users reach the frontend through `Route53 -> CloudFront -> S3`, while API traffic follows `Route53 -> EC2 -> Caddy -> backend container -> PostgreSQL 16`. Release automation is handled from GitHub Actions, and database backups are stored in a separate S3 bucket rather than mixed with frontend artifacts.

## AWS Infrastructure & IaC

The infrastructure runs on a single EC2 host in ap-northeast-2 (Seoul). The frontend is served from S3 through CloudFront with OAC. Route53 handles DNS for both the frontend domain and the API subdomain. A separate S3 bucket is used exclusively for PostgreSQL backups. Terraform files in this repository demonstrate the infrastructure shape using upstream modules — real account IDs, bucket names, and operational values are not included.

## CI/CD

GitHub Actions was a practical fit because the application is relatively small and already lives in GitHub. It was simpler to keep source control and delivery automation in one place than to introduce the operational overhead of a separate GitLab installation. The release flow is split into frontend deploy, backend deploy, and controlled migrations rather than hiding everything behind one opaque pipeline.

## Database & Backups

PostgreSQL 16 runs privately on the application host in Docker Compose. That keeps the footprint compact while the system remains small, but the database is still treated as a first-class operational concern: migrations are separated from app deploys, logical dumps go to a dedicated backup bucket, and restore validation is part of the intended operating model.

## SRE / Operability

The repository is sanitized by design, and the runtime stays behind clear boundaries: TLS at the public edges, PostgreSQL not exposed to the Internet, least-privilege automation, separated backup storage, and explicit rollback and recovery thinking. The goal is not to overstate the system, but to show a calm and production-minded baseline.
