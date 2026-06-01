# Architecture

[Back to Home](index.md){ .md-button .nav-button }

![LabelMaster / Potaglab architecture](assets/architecture-diagram.svg)

The production shape behind this portfolio is intentionally pragmatic. The frontend is a static SPA served from S3 through CloudFront, the API runs on a single EC2 host, Caddy handles the public entry point and TLS for the backend, and PostgreSQL 16 stays private inside the same Docker Compose stack. That layout is not meant to imitate a hyperscale system. It is meant to keep the early production footprint understandable, cheap, and operationally predictable.

The split between frontend delivery and API runtime is doing most of the useful work here. Static assets are pushed to S3 and cached globally by CloudFront, while dynamic traffic is routed to a VM that can be updated on its own cadence. This keeps frontend deploys lightweight and makes it possible to talk about cache invalidation, rollback, and edge behavior separately from backend release concerns.

## Traffic Model

- Users -> Route53 -> CloudFront -> S3 frontend
- API domain -> Route53 -> EC2 -> Caddy -> backend container -> PostgreSQL 16
- GitHub Actions -> S3/CloudFront deploy + SSH backend deploy + controlled migrations
- Backups -> separate S3 backup bucket

## Diagram Walkthrough

The top-left path is the frontend delivery route. Users hit the public domain, Route53 resolves the record, CloudFront handles TLS and edge caching, and the built SPA is served from the S3 frontend bucket. This keeps static delivery decoupled from the application host and makes cache invalidation part of the release process instead of part of backend runtime behavior.

The API path is intentionally separate. A dedicated API hostname resolves through Route53 to the EC2 application host, where Caddy terminates TLS and forwards requests to the backend container. PostgreSQL 16 stays private behind that runtime boundary and is only reachable from the application stack.

The lower release lane shows how GitHub Actions interacts with the system. Frontend artifacts are deployed to S3 and invalidated in CloudFront, while backend updates go through SSH-driven deployment on the EC2 host. Migrations are kept as an explicit controlled step because they change the rollback story more than static assets or container refreshes.

The backup bucket is drawn separately on purpose. Database dumps are not mixed with frontend artifacts, which keeps retention, access policy, and recovery workflows easier to reason about.

## Request Paths

For the browser experience, the user hits the public domain, Route53 resolves it to CloudFront, and CloudFront serves the built frontend from S3. Error handling maps `403` and `404` back to `index.html`, which keeps SPA routing clean without pushing that concern into the application runtime.

For API traffic, the browser calls a separate public hostname. Route53 resolves that hostname to the EC2 instance, Caddy terminates TLS and forwards the request to the backend container, and the backend talks to PostgreSQL over the local private network created by Docker Compose. The database is therefore not exposed as a public service at all.

There is also an optional helper flow for user-supplied format assets. In the documented design, the frontend can request a signed upload URL from a small Lambda endpoint, upload directly into a private S3 bucket, and trigger an SES-backed notification flow. That keeps binary intake away from the main runtime while still fitting the overall AWS footprint.

## Related Artifacts

- Terraform: [`infra/terraform/`](https://github.com/Markovskoy/pack-label-wise-portfolio/tree/main/infra/terraform)
- Runtime: [`infra/docker-compose.example.yml`](https://github.com/Markovskoy/pack-label-wise-portfolio/blob/main/infra/docker-compose.example.yml)
- Reverse proxy: [`infra/caddy.example`](https://github.com/Markovskoy/pack-label-wise-portfolio/blob/main/infra/caddy.example)

## Why This Shape Was Chosen

I kept the system small on purpose. A single EC2 host is enough to demonstrate reverse proxying, containerized runtime management, PostgreSQL operations, controlled deployment hooks, and backup discipline without introducing infrastructure that the workload does not need yet. S3 and CloudFront are an easy win because they reduce load on the application host and make frontend releases more deterministic.

The database stays on the same VM for the same reason: it minimizes moving parts while the platform is still relatively compact. That does not mean the design is treated as final. The repo documents a clear path toward RDS once higher availability, stronger isolation, or operational overhead justify the shift.

## Technology Boundary

The public repository intentionally omits the proprietary backend, but the frontend stack observed from the private codebase included React 18, TypeScript, Vite, Tailwind CSS, Radix/shadcn UI primitives, TanStack Query, and export/import libraries such as `xlsx`, `jspdf`, and `pptxgenjs`. I kept that context here because it explains why the deployment is split into static asset delivery plus an API runtime rather than a purely server-rendered model.

## What Is Deliberately Missing

The private product logic, the real schema, real operational naming, customer data, and exact production identifiers are not part of this repository. The goal is to preserve the engineering story, not to publish sensitive implementation detail.

[Back to Home](index.md){ .md-button .nav-button }
