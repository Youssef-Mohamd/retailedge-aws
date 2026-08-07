# Migration Strategy

RetailEdge has a 90-day migration window, so the strategy favors managed services and minimal application change.

| Component | Strategy | Justification |
|---|---|---|
| Web server | Replatform | Move Apache/PHP to EC2 behind an ALB and Auto Scaling without rewriting the application. |
| Application | Replatform | Preserve the existing application while replacing manually managed capacity with Auto Scaling. |
| Database | Replatform | Keep MySQL while moving operational responsibilities to RDS. |
| Static assets | Replatform | Move static assets to S3 and use CloudFront for delivery. |

## 6 Rs Position

The dominant choice is **Replatform**. A full refactor is outside the 90-day migration window, while a simple rehost would not solve the availability and operational problems that motivated the migration.

## Migration Sequence

1. Build and validate the AWS network.
2. Launch application capacity and validate the ALB health checks.
3. Provision RDS and Redis.
4. Use AWS DMS for full load followed by CDC.
5. Validate the application against RDS.
6. Lower DNS TTL and perform a weighted Route 53 cutover.
7. Monitor the new environment and retain rollback capability during the agreed rollback window.
