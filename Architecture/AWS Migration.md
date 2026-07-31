# RetailEdge Inc. — AWS Migration: Layer 1

---

## Task 1.2 — Migration Strategy

### Strategy Table

| Component | Strategy | Justification |
| :--- | :--- | :--- |
| **Web Server** (Apache) | **Replatform** | Move to EC2 + ALB + Auto Scaling. No code changes, just config. |
| **Application** (PHP/Laravel) | **Replatform** | Move to EC2 + ElastiCache Redis. No code changes, just cache setup. |
| **Database** (MySQL) | **Replatform** | Move to RDS Multi-AZ for HA & automatic failover. No schema changes. |
| **Static Assets** | **Replatform** | Move to S3 + CloudFront for faster delivery & lower EC2 load. |

**Why Replatform over Refactor?** 90-day timeline, no time for full rewrite.

---

## Task 1.3 — TCO Comparison

### AWS Cost Estimate (On-Demand, us-east-1)

| Service | Monthly Cost |
| :--- | :--- |
| EC2 (2 × t3.small) | $74.50 |
| RDS (db.t3.small, Multi-AZ) | $112.79 |
| S3 (100 GB Standard) | $3.65 |
| ALB (1, 2 AZs) | $615.03 |
| NAT Gateway (2 × 50 GB) | $206.10 |
| **Total** | **$1,012.07** |

**Annual Cost:** $12,144.84

---

### 3-Year Projection

| Year | On-Premises | AWS | Savings |
| :--- | :--- | :--- | :--- |
| Year 1 | $18,000 | $12,145 | $5,855 |
| Year 2 | $18,000 | $12,145 | $5,855 |
| Year 3 | $18,000 | $12,145 | $5,855 |
| **Total** | **$54,000** | **$36,435** | **$17,565** |

---

### Cost Optimization (Reserved Instances)

| Scenario | Annual Cost | 3-Year Cost | Savings |
| :--- | :--- | :--- | :--- |
| On-Demand | $12,145 | $36,435 | $17,565 |
| Reserved (70% off) | ~$6,000 | ~$18,000 | **$36,000** |

---

