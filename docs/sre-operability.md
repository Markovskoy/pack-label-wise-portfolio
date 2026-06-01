# SRE / Operability

## Reliability Goals

- Keep frontend delivery independently recoverable from backend runtime issues
- Make backend releases reversible
- Keep database recovery procedure explicit and testable
- Reduce surprise by separating release, migration, and rollback concerns

## Rollback Concept

### Frontend

- Re-deploy the previous build artifact to S3
- Re-run CloudFront invalidation if required
- Verify `index.html` and asset references after rollback

### Backend

- Re-deploy the previous known-good container image or git revision on the EC2 host
- Confirm Caddy health and API readiness
- If a migration was destructive, require restore/runbook decision rather than blind rollback

## Health Checks

- CDN reachability check for the frontend domain
- API readiness endpoint for reverse proxy and app runtime
- Database connectivity check from the backend container
- Post-deploy smoke flow: login, product lookup, shipment fetch, export path

## Logging Plan

- Caddy access/error logs
- Application stdout/stderr logs from Docker runtime
- PostgreSQL logs for connection and error visibility
- Centralization target: CloudWatch, Loki, or another log aggregator

## Metrics Plan

- Availability checks for frontend and API
- Host CPU, memory, disk, and inode usage
- Container restart count
- PostgreSQL connection count, storage growth, slow query indicators
- Deployment frequency and failed deployment count

## Backup And Restore Plan

- Scheduled PostgreSQL logical dumps to a separate backup bucket
- Encryption at rest
- Retention policy with lifecycle rules
- Recurring restore validation into isolated environment

## Incident Response Checklist

1. Confirm scope: frontend only, API only, or database issue.
2. Check the latest deployment and migration history.
3. Review reverse proxy, app, and database logs.
4. Verify DNS/CDN reachability if the symptom is user-facing.
5. Roll back the affected layer if a recent release is responsible.
6. If data integrity is at risk, freeze deploys and move to restore decision path.
7. Document timeline, cause, mitigation, and follow-up actions.

## Cost Control

- Use AWS Budgets with alert thresholds
- Tag runtime, storage, and backup resources clearly
- Watch CloudFront transfer, S3 storage, EC2 sizing, and backup growth
- Review whether single-host Postgres remains cheaper than RDS only after factoring in operational overhead

## Next Maturity Steps

- Synthetic probes for public endpoints
- Automated restore-test job
- Centralized metrics and alerting stack
- RDS migration ADR when scale justifies it
