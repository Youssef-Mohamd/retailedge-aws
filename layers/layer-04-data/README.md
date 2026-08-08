# Layer 4 — Data Layer and Migration

## Assignment configuration

Production-oriented RDS configuration uses:

- MySQL.
- Multi-AZ enabled.
- Storage encryption enabled.
- Seven-day backup retention.
- gp3 storage.

Production Redis uses two nodes with automatic failover, Multi-AZ, encryption at rest, and encryption in transit.

S3 is private, versioned, and encrypted. Production enables Intelligent-Tiering.

## Sandbox configuration

The sandbox is optimized for the AWS Free Tier / Free Plan:

- RDS MySQL `db.t3.micro`.
- Single-AZ.
- 20 GB gp2 storage for compatibility with the legacy RDS Free Tier allowance.
- Seven-day backup retention.
- Redis `cache.t3.micro` with one node when enabled.
- S3 Intelligent-Tiering is disabled to avoid adding tiering-related usage to a small sandbox workload.

AWS's current Free Tier changed on July 15, 2025. Newer accounts use Free/ Paid plans with AWS credits, while accounts activated before that date can retain the legacy Free Tier. RDS `db.t3.micro` is eligible on the current Free plan, while the legacy offer includes Single-AZ usage and 20 GB gp2 storage. ElastiCache `cache.t3.micro` is covered by the legacy Free Tier; newer Free Plan accounts consume AWS credits, so the remaining credit balance must be checked before enabling Redis.

## Secrets

The database password is a sensitive Terraform variable and must never be committed. Provide it through an environment variable or a local `.tfvars` file that is ignored by Git.

## Validation

Run `terraform fmt -check`, `terraform init -backend=false`, `terraform validate`, and `terraform plan` before apply. Confirm the plan contains only the intended data resources.
