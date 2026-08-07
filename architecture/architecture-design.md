# RetailEdge AWS Architecture Design

## Business Context

RetailEdge is a mid-size e-commerce platform with 200,000 monthly active users and Black Friday traffic peaks. The migration must address seasonal downtime, slow manual deployments, and the 90-day co-location renewal window.

## Target Three-Tier Architecture

### Web tier
- Route 53 for DNS and weighted cutover.
- CloudFront for static content and edge caching.
- Application Load Balancer across two Availability Zones.

### Application tier
- EC2 Auto Scaling Group across two Availability Zones.
- Production target: min 2, desired 2, max 10.
- Instances remain in private subnets and receive traffic only through the ALB.

### Data tier
- Amazon RDS for MySQL with Multi-AZ in the production architecture.
- ElastiCache for Redis with a primary and replica in production.
- Amazon S3 for static assets.

## Network Layout

| Tier | AZ-a | AZ-b | Internet access |
|---|---|---|---|
| Public | 10.0.1.0/24 | 10.0.2.0/24 | Internet Gateway |
| Private | 10.0.11.0/24 | 10.0.12.0/24 | None |
| Database | 10.0.21.0/24 | 10.0.22.0/24 | None |

The application and database tiers do not have direct Internet Gateway access. NAT Gateway is not included because it is not required by the project.

## Sandbox Profile

The AWS sandbox uses the same architecture boundaries while reducing continuously running resources:

- EC2: 1 desired, max 2.
- RDS: `db.t3.micro`, Single-AZ.
- Redis: one small node when the sandbox account has sufficient Free Plan credits.
- No NAT Gateway or NAT Elastic IP.
- HTTPS/CloudFront/Route 53 are production capabilities; sandbox validation can use the ALB HTTP listener when no domain/certificate is available.

AWS's current Free Plan provides new accounts with credits and has different eligibility rules from older Free Tier accounts. EC2 `t3.micro` and `t3.small` are currently listed as eligible instance types for accounts created on or after July 15, 2025, while RDS Free Tier supports `db.t3.micro`/`db.t4g.micro` and excludes Multi-AZ. Verify the actual account's Free Tier/credit status before deployment.

## Availability and Security

The production design survives an Availability Zone failure through multi-AZ load balancing, application capacity in two AZs, and RDS Multi-AZ failover. Security Groups enforce ALB → application → data communication and prevent direct internet access to application and database instances.
