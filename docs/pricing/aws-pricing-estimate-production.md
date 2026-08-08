# RetailEdge AWS Pricing Estimate — Production

**Estimate date:** 2026-08-08  
**Region:** US East (N. Virginia) (`us-east-1`)  
**Pricing model:** On-Demand unless otherwise stated

## Summary

| Item | Estimate |
|---|---:|
| Upfront cost | $0.00 |
| Monthly cost | **$185.12** |
| 12-month cost | **$2,221.44** |

> Source: AWS Pricing Calculator export dated 2026-08-08. The calculator states that this is an estimate only and that actual charges depend on usage and applicable pricing/discounts.

## Services

| Service | Configuration | Monthly estimate |
|---|---|---:|
| Amazon EC2 | 2 × `t3a.small`, Linux, On-Demand, 100% utilization | $27.45 |
| Amazon ElastiCache | Redis OSS, 2 × `cache.t3.micro`, Standard, On-Demand | $24.82 |
| Amazon RDS for MySQL | 1 × `db.t3.small`, Multi-AZ, 100 GB gp3, On-Demand | $90.89 |
| Elastic Load Balancing | 1 × Application Load Balancer | $22.27 |
| Amazon S3 | 100 GB Standard, 10,000 PUT/COPY/POST/LIST, 100,000 GET/other requests | $2.39 |
| Amazon CloudFront | 100 GB data transfer out, 1M HTTPS requests | $9.50 |
| Amazon Route 53 | 1 hosted zone, 1M standard queries/month | $0.90 |
| Amazon CloudWatch | 20 metrics, 1 GB standard logs ingested, 4 standard-resolution alarm metrics | $6.90 |
| **Total** | | **$185.12/month** |

## Services intentionally excluded

The current RetailEdge architecture does **not** use the following services/features, so they are not part of this estimate:

- Amazon ECR
- Docker/container-based deployment
- Amazon SNS
- NAT Gateway

## Important pricing notes

### CloudFront

The calculator output shows $9.50/month for the entered CloudFront usage. The calculator page also notes that the first 1 TB/month of data transfer out to the internet and the first 10 million HTTP/HTTPS requests are free under the applicable CloudFront allowance and asks users to manually exclude those amounts. Therefore, the effective CloudFront charge should be reviewed against the account's actual eligibility and free allowance before using the calculator subtotal as the final billed amount.

### Free-tier / account-specific discounts

The AWS Pricing Calculator export explicitly states that its estimates do not include all taxes and that actual fees depend on usage and other factors. Free-tier eligibility and account-specific credits should be checked separately before deployment.

## Scope

This document represents the **Production** pricing profile only. A separate Sandbox estimate should be created with the smaller sandbox resource sizes and cost controls defined by the repository.

## Source

AWS Pricing Calculator export: `d5d1ae82-d846-4969-9fd1-d1aeedcc7cf6.pdf` (export date 2026-08-08).
