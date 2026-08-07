# RetailEdge AWS Migration

The current source of truth for Layer 1 is now:

- `layers/layer-01-architecture/README.md`
- `architecture/architecture-design.md`
- `architecture/migration-strategy.md`
- `architecture/tco.md`

## Migration strategy

| Component | Strategy | Justification |
|---|---|---|
| Web server | Replatform | Move Apache/PHP to EC2 behind ALB and Auto Scaling without a rewrite. |
| Application | Replatform | Keep the application while replacing manually managed capacity with Auto Scaling and managed caching. |
| Database | Replatform | Move MySQL to RDS while keeping the same database engine. |
| Static assets | Replatform | Store assets in S3 and deliver them through CloudFront. |

## Cost model

The earlier Pricing Calculator estimate in this repository is retained as a planning reference. It is not a Free Plan guarantee and should not be used as the expected sandbox bill.

The sandbox profile deliberately reduces continuously running resources: RDS Single-AZ, a small ASG, optional single-node Redis, and no NAT Gateway by default.

## Migration sequence

1. Network foundation.
2. Compute and ALB.
3. RDS, Redis, and S3.
4. DMS full load and CDC rehearsal.
5. CI/CD, monitoring, and rollback validation.
6. Weighted Route 53 cutover.
