# Publishing Guide

## 1. Final Sanity Check

- Search the repository for real domains, IPs, IDs, usernames, and bucket names.
- Replace remaining placeholders in `README.md` and `mkdocs.yml` with your public GitHub username and repository name.
- Decide which screenshots are safe to publish and redact them if needed.

## 2. Create The Public GitHub Repository

Suggested name options:

- `packlabel-aws-case-study`
- `labelmaster-devops-portfolio`
- `packlabel-platform-case-study`

Recommended visibility: `Public`

## 3. Push The Repository

```bash
cd ../pack-label-wise-portfolio
git add .
git commit -m "Initial public portfolio case study"
git remote add origin git@github.com:<github-username>/<repo-name>.git
git push -u origin main
```

## 4. Enable GitHub Pages

### Simple option

- GitHub -> Settings -> Pages
- Source -> `Deploy from a branch`
- Branch -> `main`
- Folder -> `/docs`

This works immediately for the Markdown docs view.

### Better-looking option with MkDocs

1. Install MkDocs Material locally.
2. Update `site_url` and `repo_url` in `mkdocs.yml`.
3. Build or deploy the docs site.

Example:

```bash
pip install mkdocs-material
mkdocs serve
mkdocs build
```

If you want, add a dedicated GitHub Pages workflow later for MkDocs deployment.

## 5. Replace Placeholders Before Publishing

- `https://<github-username>.github.io/<repo-name>/`
- `https://github.com/<github-username>/<repo-name>`
- optional public demo references if you decide to add them

Do not replace infrastructure placeholders like `<aws-account-id>` or `<cloudfront-distribution-id>`.

## 6. LinkedIn Project Entry

### Title

`LabelMaster / Potaglab - AWS DevOps & SRE Case Study`

### Description

Built and documented a production-style logistics labeling platform deployed on AWS. The project focuses on DevOps/SRE practices: S3 + CloudFront static delivery, EC2 + Docker Compose runtime, Caddy reverse proxy, PostgreSQL operations, GitHub Actions release automation, controlled migrations, and security-conscious deployment design. Public repository contains sanitized infrastructure and CI/CD examples only; proprietary application code remains private.

### Skills To Tag

- AWS
- GitHub Actions
- Docker Compose
- PostgreSQL
- CI/CD
- DevOps
- SRE
- CloudFront
- Amazon S3
- EC2
- Caddy
- Release Engineering

## 7. Best Portfolio Presentation Order

1. Pin the GitHub repository.
2. Add the GitHub Pages link in the LinkedIn project URL field.
3. Add 2-4 screenshots to the LinkedIn project media gallery.
4. In your profile headline or About section, reference AWS delivery and CI/CD ownership.

## 8. Nice Final Touches

- Replace mock visuals with redacted real screenshots
- Add one architecture slide PDF for recruiters
- Add one incident/rollback example as a future improvement
