# LabelMaster / Potaglab

<section class="hero-panel hero-panel-single">
  <div class="hero-copy hero-copy-wide">
    <div class="hero-kicker">Sanitized DevOps / AWS portfolio case</div>
    <h1>How I deployed and operated LabelMaster in AWS</h1>
    <p>
      LabelMaster is a private logistics labeling web application for importing products from Excel,
      managing shipments, and exporting labels to PDF or PPTX. This repository is a public-safe portfolio
      version focused on the DevOps part: AWS infrastructure, Terraform layout, GitHub Actions delivery,
      PostgreSQL operations, backups, and basic production hardening.
    </p>
    <p>
      The real application code, secrets, and production identifiers are intentionally not published.
      What is left here is the part that is useful in an interview or portfolio review: how the platform
      is structured, how it is released, and what was done to keep it operable.
    </p>
    <div class="hero-meta">
      <span>AWS</span>
      <span>S3 + CloudFront</span>
      <span>EC2 + Docker Compose</span>
      <span>Caddy</span>
      <span>PostgreSQL 16</span>
      <span>GitHub Actions</span>
    </div>
  </div>
</section>

## Architecture

```text
Users
  |
  +--> potaglab.com / www.potaglab.com
  |      Route53 -> CloudFront -> S3 frontend bucket
  |
  +--> api.potaglab.com
         Route53 -> EC2 Elastic IP -> Caddy -> backend container -> PostgreSQL 16

GitHub Actions
  |
  +--> frontend build -> S3 sync -> CloudFront invalidation
  +--> backend deploy over SSH -> docker compose update on EC2
  +--> controlled DB migration step

Backups
  |
  +--> PostgreSQL logical dumps -> separate S3 backup bucket
```

The production shape is intentionally simple. The frontend is served from `S3 + CloudFront`, the API runs on a single `EC2` host behind `Caddy`, and `PostgreSQL 16` stays private on the same host in Docker Compose. That kept infrastructure small, reduced moving parts, and still gave clear boundaries between edge delivery, application runtime, and data.

<details class="portfolio-block" open>
  <summary>AWS</summary>

The public website is served from S3 through CloudFront, with Route53 handling the public domains. API traffic goes to `api.potaglab.com`, which resolves to an EC2 host with an Elastic IP. On that host, Caddy terminates TLS and proxies requests to the backend container. PostgreSQL runs privately in the same Docker Compose stack and is not exposed to the Internet.

This shape is not about pretending the system is huge. It is about showing a production setup that is reasonable for the project size, easy to operate, and cheap enough to keep under control.
</details>

<details class="portfolio-block">
  <summary>Terraform</summary>

Terraform in this portfolio is presented the same way I would use it in practice: mostly by wiring together proven upstream modules and adding project-specific values around them. The repo includes a sanitized `infra/terraform/` layout for S3, CloudFront, Route53, EC2, security groups, IAM policy for deploys, and backup storage.

It is intentionally not framed as “I wrote every Terraform resource from scratch”. The idea is closer to real work: take stable modules from public repositories, plug in the project values, keep the structure readable, and use Terraform as the source of truth for the AWS layer.
</details>

<details class="portfolio-block">
  <summary>CI/CD</summary>

The deployment flow is organized around GitHub Actions. Feature branches do not deploy. Release branches are used to prepare a cut, and production rollout happens when a release branch is merged into `main` or when a manual dispatch is used intentionally.

The pipeline is split into the parts that matter operationally: frontend lint/build, frontend upload to S3, CloudFront invalidation, backend deployment to EC2 over SSH, and a separate migration step for PostgreSQL. There is also a quality workflow with linting and a SonarQube stage to show the quality gate shape in GitHub, even though the public repo does not contain the real secret-backed scanner configuration.

Relevant files:

- `.github/workflows/release.yml`
- `.github/workflows/quality.yml`
- `.github/workflows/pages.yml`
</details>

<details class="portfolio-block">
  <summary>Database and backups</summary>

The current production database is PostgreSQL 16 in Docker on the application host. That choice keeps the setup simple while the system is still small. Migrations are treated as a separate deployment stage, not something hidden inside an app restart. Backups are planned as logical dumps stored in a separate S3 bucket, with restore validation as the next operational improvement.
</details>

<details class="portfolio-block">
  <summary>Security</summary>

The public repository is sanitized on purpose: no real secrets, no customer data, no real account identifiers, no private URLs beyond the public site, and no proprietary backend source. On the runtime side, PostgreSQL is not public, TLS is terminated at the edge and at the API entrypoint, deployment access is kept separate, and backup storage is split from frontend artifact storage.
</details>

## Project links

- Public site: [https://potaglab.com](https://potaglab.com)
- Portfolio repo: [https://github.com/Markovskoy/pack-label-wise-portfolio](https://github.com/Markovskoy/pack-label-wise-portfolio)
