# RetailEdge AWS Infrastructure

AWS migration and cloud infrastructure implementation for the RetailEdge three-tier application.

## Project layers

- **Layer 1 — Discovery & Architecture Design:** architecture diagram, migration strategy, TCO, and design decisions.
- **Layer 2 — Network Foundation & Security:** VPC, public/private/database subnets, routes, and least-privilege Security Groups.
- **Layer 3 — Compute & Auto Scaling:** ALB, Launch Template, Auto Scaling Group, target tracking, instance refresh, and scheduled scaling.
- **Layer 4 — Data & Migration:** RDS MySQL, ElastiCache Redis, S3, and the DMS cutover plan.
- **Layer 5 — CI/CD & Go-Live:** GitHub Actions OIDC, S3 artifacts, SSM-based deployment, CloudWatch alarms, and the go-live checklist.

The structure follows the original project rubric: 20 points per layer, 100 points total, with the bonus work documented where applicable.

## Repository structure

```text
retailedge-aws/
├── app/
│   └── app.py
├── ami/
│   └── user-data.txt
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

The application deployment path is:

```text
GitHub push
    ↓
GitHub Actions
    ↓
Python validation + smoke test
    ↓
ZIP application artifact
    ↓
S3 artifact bucket
    ↓
AWS Systems Manager Run Command
    ↓
EC2 instances in the RetailEdge sandbox ASG
    ↓
Restart retailedge.service
    ↓
/health check
```

GitHub Actions authenticates to AWS through GitHub OIDC rather than long-lived AWS access keys. EC2 instances use an IAM instance profile with S3 read access and Systems Manager management permissions.

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

The repository does not use Docker, Amazon ECR, Amazon SNS, or CodeDeploy. CloudWatch alarms remain as monitoring controls, while notification delivery is intentionally outside the current architecture.

Application deployment is handled without CodeDeploy: GitHub Actions publishes a versioned application artifact to S3 and uses AWS Systems Manager Run Command to update the running EC2 instances and restart the systemd service.

## Application

The sandbox application is a dependency-free Python HTTP service listening on port `8080`.

- `/` — RetailEdge landing page.
- `/health` — ALB health check endpoint returning `200 OK`.
- `/info` — JSON service information and deployment status.

The application source is kept under `app/app.py`; the AMI bootstrap script is responsible for Python/systemd provisioning and does not overwrite the application source.

## Pricing

The Production AWS Pricing Calculator estimate is documented in [`docs/pricing/aws-pricing-estimate-production.md`](docs/pricing/aws-pricing-estimate-production.md).

The exported estimate is based on US East (N. Virginia) and reports an estimated $185.12/month before account-specific free-tier adjustments and other discounts.

## Secrets

Never commit AWS credentials, database passwords, or private SSH keys. Real passwords belong in local ignored tfvars files or another secret-management mechanism.

## Validation

From each layer directory:

```bash
terraform fmt -check
terraform init
terraform validate
terraform plan -var-file=../../environments/sandbox/layer-XX-*.tfvars
```

Review the plan before `terraform apply`.

## GitHub Actions setup

Add the following repository secret before running `deploy.yml`:

```text
AWS_ROLE_ARN=arn:aws:iam::<account-id>:role/retailedge-sandbox-github-actions
```

The workflow uses OIDC and therefore does not require an AWS access key or secret key in GitHub.

## Important

The original starter `terraform/` directory is being replaced by the layer-based structure. The old files are kept only until the new implementation has been reviewed; they are not the source of truth.
