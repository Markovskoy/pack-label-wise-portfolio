# LabelMaster / Potaglab

Sanitized DevOps/SRE portfolio case study for a production logistics labeling platform deployed on AWS. The public repository is focused on how the platform is delivered and operated: `S3 + CloudFront` for the frontend, `EC2 + Docker Compose` for the application runtime, `Caddy` for TLS and reverse proxying, `PostgreSQL 16` for state, and `GitHub Actions` for controlled releases.

The product itself is private. Real source code, secrets, customer data, account identifiers, and operational names are intentionally not included here. This repository is a public-safe engineering narrative showing the infrastructure shape, release flow, database approach, security posture, and operability decisions behind the deployment.

I used this project to demonstrate the part I owned directly: packaging the runtime, documenting AWS infrastructure, structuring Terraform around reusable upstream modules, setting up CI/CD gates, separating migrations from app deploys, defining backup and restore expectations, and making the system explainable to another engineer without exposing private implementation details.

The production-facing website is available at [potaglab.com](https://potaglab.com). This portfolio repo documents the platform around it rather than mirroring the proprietary application code.

![Architecture diagram](docs/assets/architecture-diagram.svg)

More detail lives in the MkDocs site under `docs/`:

- [Architecture](docs/architecture.md)
- [CI/CD](docs/cicd.md)
- [AWS Infrastructure](docs/aws-infrastructure.md)
- [Database](docs/database.md)
- [Security](docs/security.md)
- [SRE / Operability](docs/sre-operability.md)
- [Roadmap](docs/roadmap.md)

Key public-safe artifacts included in the repository:

- Terraform examples under [`infra/terraform/`](infra/terraform/)
- Runtime examples under [`infra/docker-compose.example.yml`](infra/docker-compose.example.yml) and [`infra/caddy.example`](infra/caddy.example)
- Release and quality pipelines under [`.github/workflows/`](.github/workflows/)
- Sample migration under [`db/migrations-sample/001_init_schema_sample.sql`](db/migrations-sample/001_init_schema_sample.sql)

If you want the rendered version, the GitHub Pages site is configured for MkDocs Material and published from this repository.
