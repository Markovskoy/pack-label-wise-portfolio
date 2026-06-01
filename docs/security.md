# Security

The first security decision in this repository is what not to publish. The public portfolio contains no secrets, no real account identifiers, no real bucket names, no live endpoints, no private dumps, and no proprietary backend source. That sanitization is part of the engineering work, not an afterthought, because a useful public case study should still respect production boundaries.

At runtime, the platform follows a simple exposure model. Static content is served over HTTPS through CloudFront. API traffic terminates at Caddy on the EC2 host. PostgreSQL is kept off the public network entirely and is only reachable by the application runtime. That keeps the attack surface smaller and makes the network story easier to reason about.

## Authentication Boundary

The application uses JWT-based authentication, but the public repo only documents the boundary, not the private implementation. The same applies to email verification flows. The design notes here focus on the things that matter for review: short-lived verification material, single-use semantics, hashed storage for codes where appropriate, and keeping auth-related endpoints rate-limited.

## Hardening Posture

The repository reflects a fairly standard but practical hardening baseline: least-privilege AWS automation, dedicated deploy access instead of shared admin credentials, SSH restricted to known networks when possible, TLS at both the frontend and API entry points, and backups stored separately from primary artifacts. Caddy headers, bucket separation, and sanitized IAM examples are all part of telling that story clearly.

## Public-Safe Limits

Some details are intentionally withheld because publishing them would add risk without adding much value. Exact production naming, private runbooks, internal topology nuance, customer data shape, and secrets-backed pipeline configuration stay out of the repo. What remains is enough to discuss the security model like an engineer without turning the portfolio into an information leak.
