# Layer 1 — Discovery and Architecture Design

This layer contains the design decisions required by the RetailEdge brief. It is documentation only; AWS resources are implemented by Layers 2–5.

## Deliverables

- Target three-tier architecture.
- Migration strategy and justification.
- TCO comparison.
- Production versus sandbox deployment profile.

## Required services

Route 53, CloudFront, Application Load Balancer, EC2 Auto Scaling, RDS MySQL, ElastiCache Redis, and S3.

## Migration strategy

| Component | Strategy | Reason |
|---|---|---|
| Web server | Replatform | Move Apache/PHP to EC2 without a rewrite. |
| Application | Replatform | Keep the existing application while gaining Auto Scaling and managed caching. |
| Database | Replatform | Move MySQL to RDS and gain managed backups and production HA. |
| Static assets | Replatform | Store assets in S3 and deliver them through CloudFront. |

See `architecture/architecture-design.md`, `architecture/migration-strategy.md`, and `architecture/tco.md`.
