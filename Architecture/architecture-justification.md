# RetailEdge AWS Architecture Justification

## Target architecture

RetailEdge moves from three co-located bare-metal LAMP servers to a three-tier AWS architecture serving 200,000 monthly active users and Black Friday peaks.

The required production services are Route 53, CloudFront, Application Load Balancer, EC2 Auto Scaling, RDS MySQL Multi-AZ, ElastiCache Redis, and S3.

## Web tier

- Route 53 provides DNS and supports the weighted cutover.
- CloudFront caches static assets near users.
- ALB distributes application traffic across Availability Zones and performs health checks.
- Migration strategy: **Replatform**. The existing Apache/PHP application can move to EC2 without a rewrite.

## Application tier

- EC2 Auto Scaling runs in private subnets across two Availability Zones.
- Production configuration is min 2, desired 2, max 10.
- Target tracking uses 60% average ASG CPU.
- Migration strategy: **Replatform**. The application is kept while capacity and deployment operations are managed by AWS.

## Data tier

- RDS MySQL Multi-AZ is the production database.
- ElastiCache Redis reduces repeated database reads.
- S3 stores static assets.
- Migration strategy: **Replatform**. MySQL remains MySQL while operational tasks move to managed RDS.

## Network isolation

| Tier | AZ-a | AZ-b | Internet access |
|---|---|---|---|
| Public | 10.0.1.0/24 | 10.0.2.0/24 | Internet Gateway |
| Private | 10.0.11.0/24 | 10.0.12.0/24 | NAT only when required |
| Database | 10.0.21.0/24 | 10.0.22.0/24 | None |

Security Groups enforce ALB → App → RDS and App → Redis. Database subnets have no route to the Internet Gateway.

## Sandbox

The sandbox keeps the same network boundaries but uses cost-controlled settings: a small ASG, RDS Single-AZ, optional single-node Redis, and no NAT Gateway by default.
