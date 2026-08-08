# Layer 5 — CI/CD, Monitoring and Go-Live

## Pipeline

The infrastructure uses GitHub Actions with OIDC for AWS authentication and CodeDeploy for server-side deployment orchestration. Docker and Amazon ECR are intentionally not part of the current architecture.

The production deployment job should use the `production` GitHub Environment when the application-specific deployment workflow is added; configure required reviewers on that environment to provide the approval gate.

## Deployment

CodeDeploy uses `CodeDeployDefault.OneAtATime` for an in-place rolling deployment to the Auto Scaling Group. Automatic rollback is enabled for deployment failure and alarm-triggered stops.

The repository does not commit a Docker-dependent deployment bundle. The final application deployment command depends on the actual RetailEdge application artifact and runtime, so that integration will be added when the application deployment contract is defined.

## Required alarms

| Alarm | Metric | Threshold | Action |
|---|---|---|---|
| High Latency | ALB p95 TargetResponseTime | > 800 ms for 5 min | CodeDeploy rollback protection |
| High Error Rate | ALB 5xx percentage | > 1% for 5 min | CodeDeploy rollback protection |
| DB CPU Spike | RDS CPUUtilization | > 80% | Monitoring only |
| Low Cache Hit Rate | ElastiCache hit percentage | < 70% | Monitoring only |

## Sandbox cost controls

- Do not create Amazon ECR repositories.
- Do not use Docker/container-based deployment.
- Do not create Amazon SNS topics.
- Do not run NAT Gateways unless a later deployment requirement genuinely needs one.
- Keep CodeDeploy and monitoring resources only where they are required by the project.
- Avoid unnecessary high-frequency custom metrics.
- Destroy the sandbox when validation is complete.

## Pricing

The Production pricing estimate is documented in `docs/pricing/aws-pricing-estimate-production.md`. The current estimate excludes ECR, Docker, SNS, and NAT Gateway because they are not part of the selected architecture.
