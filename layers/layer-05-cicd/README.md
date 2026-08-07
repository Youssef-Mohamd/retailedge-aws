# Layer 5 — CI/CD, Monitoring and Go-Live

## Pipeline

The required flow is:

`Test → Build → Push to ECR → Manual approval → CodeDeploy`

GitHub Actions authenticates to AWS using OIDC instead of long-lived AWS access keys. The production deployment job references the `production` GitHub Environment; configure required reviewers on that environment to make the approval gate active.

## Deployment

CodeDeploy uses `CodeDeployDefault.OneAtATime` for an in-place rolling deployment to the Auto Scaling Group. Automatic rollback is enabled for deployment failure and alarm-triggered stops. CodeDeploy can automatically redeploy the last known good revision when rollback is triggered.

The application instances' Golden AMI must contain Docker, the CodeDeploy agent, AWS CLI, and the application runtime required by the deployment scripts.

Because the application instances are private, CodeDeploy requires outbound HTTPS connectivity. For production this is provided through the NAT Gateway design. The sandbox keeps NAT disabled by default to control cost, so the CI/CD deployment should not be executed against the sandbox until an outbound path is deliberately enabled. The S3 gateway endpoint is free and covers S3 access, but it does not replace the CodeDeploy endpoint connectivity requirement.

## Required alarms

| Alarm | Metric | Threshold | Action |
|---|---|---|---|
| High Latency | ALB p95 TargetResponseTime | > 800 ms for 5 min | SNS + CodeDeploy rollback protection |
| High Error Rate | ALB 5xx percentage | > 1% for 5 min | SNS + CodeDeploy rollback protection |
| DB CPU Spike | RDS CPUUtilization | > 80% | SNS |
| Low Cache Hit Rate | ElastiCache hit percentage | < 70% | SNS |

## Sandbox cost controls

- Keep the ECR repository small and clean old images.
- Do not run NAT Gateways unless the deployment path genuinely needs one.
- Keep CodeDeploy and monitoring resources but avoid unnecessary high-frequency custom metrics.
- Destroy the sandbox when validation is complete.

ECR currently includes a 500 MB/month private-repository storage Free Tier for new customers for one year; usage beyond free allowances consumes the account's credits or is billed on paid plans.
