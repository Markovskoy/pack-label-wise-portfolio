# Database

## Current Deployment Pattern

- PostgreSQL 16 runs in Docker on the application EC2 host
- Storage is backed by a persistent host volume
- Database port `5432` is not exposed publicly
- Application traffic reaches PostgreSQL only through the backend runtime on the same host

## Why This Is Acceptable At This Stage

- Operationally simple for an early production workload
- Keeps infrastructure footprint small
- Works well with Docker Compose-based runtime management
- Straightforward to pair with backups and SSH-driven maintenance

## Migration Strategy

- Database migrations are treated as a separate controlled deployment stage
- Migration linting should happen before execution
- Migration execution should be idempotent and observable
- Application deploy and schema change are deliberately decoupled

## Backup Strategy

- Store backups in a separate object storage bucket
- Use compressed logical dumps as a baseline
- Define retention policy by environment and business needs
- Tag backups with timestamp and version metadata
- Encrypt backups at rest

## Restore Test Plan

1. Restore the latest dump into an isolated environment.
2. Validate schema load and application startup.
3. Run smoke queries against critical tables.
4. Record recovery time and restore issues.
5. Schedule this as a recurring operational check.

## Growth Path

- Move to RDS when write load, backup complexity, HA needs, or maintenance overhead outgrow single-host Postgres
- Introduce read replicas only when workload requires them
- Add formal RPO/RTO targets before redesigning the data layer

## Sample Artifact

- Sanitized SQL example: [`../db/migrations-sample/001_init_schema_sample.sql`](../db/migrations-sample/001_init_schema_sample.sql)
