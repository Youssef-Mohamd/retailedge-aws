# RetailEdge AWS Infrastructure

AWS migration and cloud infrastructure implementation for the RetailEdge three-tier application.

## Project layers

- **Layer 1 — Discovery & Architecture Design:** architecture diagram, migration strategy, TCO, and design decisions.
- **Layer 2 — Network Foundation & Security:** VPC, public/private/database subnets, routes, and least-privilege Security Groups.
- **Layer 3 — Compute & Auto Scaling:** ALB, Launch Template, Auto Scaling Group, target tracking, instance refresh, and scheduled scaling.
- **Layer 4 — Data & Migration:** RDS MySQL, ElastiCache Redis, S3, and the DMS cutover plan.
- **Layer 5 — CI/CD & Go-Live:** CodeDeploy, GitHub Actions OIDC, CloudWatch alarms, and the go-live checklist.

The structure follows the original project rubric: 20 points per layer, 100 points total, with the bonus work documented where applicable.

## Repository structure

```text
retailedge-aws/
├── architecture/
├── docs/
├── layers/
│   ├── layer-01-architecture/
│   ├── layer-02-network/
│   ├── layer-03-compute/
│   ├── layer-04-data/
│   └── layer-05-cicd/
├── environments/
│   └── sandbox/ and production/
├── scripts/
└── .github/workflows/
```

## Deployment approach

The Terraform roots are intentionally separated so the infrastructure can be applied and verified one layer at a time:

```text
Layer 2 Network
      ↓
Layer 3 Compute
      ↓
Layer 4 Data
      ↓
Layer 5 CI/CD + Monitoring
```

Layer 1 is documentation and does not create AWS resources.

## Sandbox versus production

The repository contains two profiles using the same architecture decisions but different resource sizes.

The sandbox is designed to reduce cost while preserving the security boundaries of the target architecture:

- RDS Single-AZ with `db.t3.micro`.
- Small EC2 Auto Scaling range.
- One Redis node when enabled and affordable for the account.
- No NAT Gateway or NAT Elastic IP.
- HTTP ALB listener is available for sandbox validation when no ACM certificate/domain is configured.

Production retains the assignment's target values such as ASG min 2 / desired 2 / max 10 and RDS Multi-AZ.

## CI/CD scope

The repository does not use Docker, Amazon ECR, or Amazon SNS. CloudWatch alarms remain as monitoring controls, while notification delivery is intentionally outside the current architecture.

CodeDeploy infrastructure remains available in Layer 5, but the application-specific deployment bundle is not committed until the application's runtime/start command is defined. This avoids keeping a Docker-dependent deployment implementation in the repository.

## Pricing

The Production AWS Pricing Calculator estimate is documented in [`docs/pricing/aws-pricing-estimate-production.md`](docs/pricing/aws-pricing-estimate-production.md).

The exported estimate is based on US East (N. Virginia) and reports an estimated $185.12/month before account-specific free-tier adjustments and other discounts.

## Secrets

Never commit AWS credentials or database passwords. Real passwords belong in local ignored tfvars files or another secret-management mechanism.

## Validation

From each layer directory:

```bash
terraform fmt -check
terraform init
terraform validate
terraform plan -var-file=../../environments/sandbox/layer-XX-*.tfvars
```

Review the plan before `terraform apply`.

## Important

The original starter `terraform/` directory is being replaced by the layer-based structure. The old files are kept only until the new implementation has been reviewed; they are not the source of truth.
