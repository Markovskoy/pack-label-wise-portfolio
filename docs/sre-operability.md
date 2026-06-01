# SRE / Operability

[Back to Home](index.md){ .md-button .nav-button }

This platform is intentionally small, but I still wanted the operational story to look like something that could survive production use. That means thinking beyond initial deployment and documenting how the system is checked, rolled back, observed, and recovered when something goes wrong.

## Release And Rollback Thinking

The frontend is the easiest layer to recover because it is just a versioned static build in S3 behind CloudFront. A previous artifact can be redeployed quickly and the CDN invalidated if needed. The backend is different: rollback means re-deploying the previous known-good container or revision on the EC2 host and checking that Caddy plus the application health endpoints are back in a stable state.

The database is where the rollback story becomes more careful. Once schema changes are involved, a blind rollback is often the wrong answer. That is why the docs separate migration execution from application deployment and route destructive failures toward a restore decision instead of pretending every release can simply be reversed with one command.

## Health Checks And Signals

Operationally, the minimum useful checks are straightforward: can users reach the frontend, does the API respond through the reverse proxy, can the application talk to PostgreSQL, and does a basic smoke path still work after deployment. Logging should cover Caddy, the application containers, and PostgreSQL. Metrics should start with host saturation, container restarts, and obvious database pressure signals before expanding into a fuller observability stack.

## Backup Discipline

Backups only matter if restore is feasible. The documented plan uses scheduled logical dumps stored in a separate bucket with retention and encryption, plus recurring restore validation into an isolated environment. That is enough to show a serious posture without inventing heavyweight infrastructure that the repository does not actually need.

## Incident Handling

The incident approach is deliberately plain: identify which layer is failing, check the most recent deploy or migration activity, inspect proxy/app/database logs, confirm DNS or CDN reachability for user-facing symptoms, and roll back only the affected layer where possible. If data integrity is in question, deploys should stop and the situation should move into a restore or recovery decision path.

## Next Operational Steps

The natural maturity upgrades are synthetic probes, centralized logs and metrics, automated restore-test evidence, and clearer SLO-style reporting. I left those as visible next steps because the portfolio is stronger when it shows both what is in place now and what I would improve next.

[Back to Home](index.md){ .md-button .nav-button }
