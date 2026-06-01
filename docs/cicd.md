# CI/CD

## Release Rules

- Pushes to `feature/*` do not deploy to production.
- Pushes to `release/*` do not deploy by themselves.
- Merge of `release/vX.Y.Z` into `main` triggers production CD.
- `workflow_dispatch` allows controlled manual execution with stage toggles.

## Release Stages

1. Release gate validates that the trigger is allowed.
2. Version resolution validates semver and exposes a release version.
3. Path detection determines whether frontend, backend, or migrations changed.
4. Frontend lint/build stages run when required.
5. Backend build is represented as a sanitized placeholder because the private backend source is not published here.
6. Migration lint and migration execution are separated from app deploy.
7. Frontend deploy uploads static assets to S3 and invalidates CloudFront.
8. Backend deploy uses a VM-side hook over SSH.

## Public-Safe Workflow Design

- Version metadata is embedded into frontend artifacts.
- Frontend deploy differentiates immutable assets from `index.html` caching.
- Release gate reduces accidental deployment from non-release branches.
- Manual toggles support partial rollout and controlled intervention.
- Migration execution is explicit, not hidden inside generic app deploys.

## Why This Matters For Portfolio Review

- Shows controlled production release thinking instead of naive `push-to-deploy`
- Demonstrates cache-aware frontend deployment on AWS
- Shows separation of lint, build, migrate, and deploy responsibilities
- Documents a realistic bridge between GitHub Actions and VM-hosted Docker Compose runtime

## Files

- Sanitized pipeline example: [`.github/workflows/release.example.yml`](../.github/workflows/release.example.yml)
- AWS/CD background: [aws-infrastructure.md](aws-infrastructure.md)
