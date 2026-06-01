# Architecture

![PackLabel architecture](assets/architecture-diagram.png)

## System Shape

The documented production shape is a pragmatic single-region AWS deployment with clear public/private boundaries:

- Static SPA frontend delivered from S3 behind CloudFront
- API routed to a single EC2 application host
- Caddy used as the public reverse proxy and TLS edge for the API
- Backend runtime isolated in Docker Compose
- PostgreSQL 16 running privately on the same host with persistent storage
- Optional Lambda-assisted intake flow for custom label format submissions

## Request Flows

### Frontend delivery

1. User opens `<app-domain>`.
2. Route53 resolves the apex or `www` record to CloudFront.
3. CloudFront serves built frontend assets from the S3 origin.
4. SPA fallback maps `403/404` to `/index.html`.

### API request path

1. Browser calls `https://<api-domain>`.
2. Route53 resolves the API record to the EC2 host.
3. Caddy terminates TLS and proxies to the backend container.
4. Backend reads and writes application data in PostgreSQL.

### Label format submission helper flow

1. Frontend requests a signed upload URL from a Lambda endpoint.
2. Browser uploads PPT/PPTX directly to a private S3 bucket.
3. Lambda stores submission metadata and sends a notification email.

## Stack Observed From The Codebase

- React 18
- TypeScript
- Vite
- Tailwind CSS
- shadcn/ui and Radix UI
- React Router v6
- TanStack Query
- `xlsx` for Excel import
- `jspdf` and `pptxgenjs` for label export
- `jsbarcode` for barcode generation

## Architectural Rationale

- S3 + CloudFront keeps frontend delivery simple, fast, and inexpensive.
- Single EC2 host reduces early-stage complexity while still allowing TLS, Dockerized runtime, and controlled release hooks.
- Dockerized PostgreSQL keeps the database private and easy to back up, while leaving a clear future migration path to RDS.
- Separate release and migration stages reduce deployment blast radius.

## Boundaries Intentionally Omitted

- Proprietary backend source
- Internal schema and business rules beyond sanitized samples
- Real production identifiers and operational naming
- Customer data, business metrics, and internal runbooks
