# Layer 4 — Data Layer and Migration

## Assignment configuration

Production-oriented RDS configuration uses:

- MySQL.
- Multi-AZ enabled.
- Storage encryption enabled.
- Seven-day backup retention.

Production Redis uses two nodes with automatic failover, Multi-AZ, encryption at rest, and encryption in transit.

S3 is private, versioned, encrypted, and configured for Intelligent-Tiering.

## Sandbox configuration

The sandbox uses `db.t3.micro`, 20 GB gp3 storage, Single-AZ, and one Redis node when enabled. AWS documents that RDS Free Tier excludes deployment options other than Single-AZ and supports `db.t3.micro`/`db.t4g.micro`. ElastiCache usage on post-July-2025 Free Plans is covered by the account credits, so the actual credit balance must be checked before enabling Redis.

## Secrets

The database password is a sensitive Terraform variable and must never be committed. Provide it through an environment variable or a local `.tfvars` file that is ignored by Git.

## Validation

Run `terraform fmt -check`, `terraform init`, `terraform validate`, and `terraform plan` before apply. Confirm the plan contains only the intended data resources.
