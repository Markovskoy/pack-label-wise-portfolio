# CI/CD

The release flow is designed to look and behave like a controlled production pipeline rather than a generic “push to main and hope” setup. In the private deployment, feature branches are for development, release branches are for preparing a cut, and production deployment happens only when a release branch is merged into `main` or when a manual workflow is triggered on purpose.

GitHub Actions was chosen for practical reasons. The application is small enough that it was easier to keep repository hosting and delivery automation in GitHub than to add the operational overhead of a separate GitLab installation. For this project, simplicity was the better trade-off.

That distinction matters because the platform has three different deployment concerns: frontend assets, backend runtime changes, and database migrations. Treating them as separate stages makes the blast radius easier to understand. It also makes it obvious where a human may want to stop, verify, or intervene.

## Release Logic

The public-safe workflow under [`.github/workflows/release.yml`](https://github.com/Markovskoy/pack-label-wise-portfolio/blob/main/.github/workflows/release.yml) shows the main idea. A release gate validates whether the workflow is allowed to continue. Version resolution turns the branch or manual input into a usable release number. Change detection then decides whether the frontend, backend, or migration stages are relevant for that run.

Frontend work is the most concrete part of the public pipeline. The assets are linted, built, uploaded as artifacts, and then deployed to S3 with different cache behavior for immutable files versus `index.html`. After that, CloudFront invalidation closes the loop.

The backend and migration jobs are represented as placeholders because the real runtime code is private, but the separation is still intentional. I wanted the repo to show that schema changes are not silently bundled into a general deploy script and that the VM-side deployment path is treated as a distinct operational step.

## Quality Pipeline

The repository also includes a sanitized quality workflow at [`.github/workflows/quality.yml`](https://github.com/Markovskoy/pack-label-wise-portfolio/blob/main/.github/workflows/quality.yml). It is deliberately portfolio-oriented: ESLint, a placeholder build check, and a SonarQube stage that documents the shape of a quality gate without pretending the public repo has the real secret-backed environment behind it. That matches the user-facing goal here: show the engineering intent clearly, even where the public version cannot actually execute the private parts.

## Why I Structured It This Way

This pipeline design demonstrates a few things I care about when describing DevOps work. First, releases should be explicit. Second, frontend delivery to a CDN has very different operational behavior from SSH-driven backend rollout on a VM. Third, database migrations deserve their own control point because they can change the rollback story more than any application artifact.

For a portfolio, that is much more valuable than a long YAML file with no explanation. The point is not the syntax of GitHub Actions. The point is that the deployment process reflects real production concerns.
