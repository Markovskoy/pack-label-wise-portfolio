# AWS Infrastructure & IaC

This repository documents a compact AWS setup built around the needs of a private production web application. The public pages use placeholders only, but the infrastructure shape is real enough to explain how the platform is delivered and why each component exists.

The frontend lives where it should live for this kind of product: in S3 behind CloudFront. That keeps the delivery path fast, cheap, and simple, while making cache behavior an explicit part of the release process. Route53 points the public domain and `www` alias at the distribution, and CloudFront handles HTTPS plus SPA fallback behavior.

The API follows a different path. It is routed to an EC2 instance that runs Caddy, the backend container, and a private PostgreSQL 16 container. I kept that runtime shape intentionally lean. It provides enough structure to show TLS termination, reverse proxying, container orchestration, backup handling, and host-level operations without inflating the architecture just for aesthetics.

## Core Components

The public-safe Terraform under [`infra/terraform/`](https://github.com/Markovskoy/pack-label-wise-portfolio/tree/main/infra/terraform) models the most visible parts of the stack: the frontend bucket, backup bucket, CloudFront distribution, Route53 records, IAM deploy policy, and the EC2 application host. The examples use ready-made upstream modules where that makes the repository look like a realistic Terraform consumer rather than a handwritten exercise from scratch.

That is also the point of showing Terraform here in this form. It is closer to normal engineering work: use stable upstream modules, wire them together around project inputs, keep the structure readable, and let Terraform remain the source of truth for the AWS side of the platform.

The backup bucket is split from frontend artifacts on purpose. Static site assets and database dumps have different retention, sensitivity, and restore workflows, so keeping them separate makes both IAM and operations easier to reason about.

There is also an optional helper path for uploading PPT or PPTX source files through a Lambda-to-private-S3 flow. I kept that in the architecture because it shows how small serverless components can be used without turning the whole platform into a serverless system.

## Infrastructure as Code

Terraform is presented here as a public-safe skeleton rather than as a drop-in production repository. It shows the main pieces of the AWS layout clearly: the S3 frontend bucket, separate backup bucket, CloudFront distribution, Route53 records, IAM deploy policy, and the EC2 application host.

Real account IDs, bucket names, production identifiers, and environment-specific values are intentionally not published. The point of the Terraform directory is to show the IaC approach, module wiring, and overall infrastructure shape without exposing sensitive production detail or pretending the public repo should be applied as-is.

## IAM And Exposure Model

Automation only needs a narrow set of AWS permissions: object access for the frontend bucket and CloudFront invalidation for release jobs. Everything else should stay out of the deploy identity. SSH access to the VM should use a dedicated deploy user and be restricted to controlled source ranges where possible. PostgreSQL is never treated as a public Internet-facing service.

## Why This Is A Good Portfolio Baseline

I wanted the AWS story to feel grounded. This is not a giant reference architecture copied from a vendor diagram. It is a believable production baseline for an application that has a real business workflow, moderate infrastructure needs, and room to evolve. The repository shows the current state honestly and leaves a visible path toward stronger isolation, managed database services, and more mature observability later.
