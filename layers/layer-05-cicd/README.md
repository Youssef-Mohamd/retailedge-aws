# Layer 5 — CI/CD, Monitoring and Go-Live

## Pipeline

The infrastructure uses GitHub Actions with OIDC for AWS authentication. Docker, Amazon ECR, and CodeDeploy are intentionally not part of the current sandbox architecture.

The GitHub Actions role is currently scoped to the CI artifact S3 bucket. The final application deployment command depends on the actual RetailEdge application artifact and runtime, so the deployment step should be added only after that contract is defined.

## CI artifact storage

Layer 5 creates a private, versioned S3 bucket for CI artifacts. Public access is blocked. GitHub Actions can upload and read objects through the OIDC-assumed IAM role without storing long-lived AWS access keys in GitHub.

## Required alarms

| Alarm | Metric | Threshold | Action |
|---|---|---|---|
| High Latency | ALB p95 TargetResponseTime | > 800 ms for 5 min | Monitoring / deployment gate when a deployment mechanism is added |
| High Error Rate | ALB 5xx percentage | > 1% for 5 min | Monitoring / deployment gate when a deployment mechanism is added |
| DB CPU Spike | RDS CPUUtilization | > 80% | Monitoring only |
| Low Cache Hit Rate | ElastiCache hit percentage | < 70% | Monitoring only |

## Sandbox cost controls

- Do not create Amazon ECR repositories.
- Do not use Docker/container-based deployment.
- Do not create Amazon SNS topics.
- Do not run NAT Gateways unless a later deployment requirement genuinely needs one.
- Do not create CodeDeploy resources because the AWS account requires a service subscription for that service.
- Keep monitoring and artifact-storage resources only where they are required by the project.
- Avoid unnecessary high-frequency custom metrics.
- Destroy the sandbox when validation is complete.

## Pricing

The Production pricing estimate is documented in `docs/pricing/aws-pricing-estimate-production.md`. The current estimate excludes ECR, Docker, SNS, CodeDeploy, and NAT Gateway because they are not part of the selected architecture.
