# RetailEdge  — AWS Architecture Design Document

## Overview

RetailEdge Inc. is an e-commerce company serving 200,000 monthly active users, currently running on 3 bare-metal servers in a co-located data center. This document describes the target AWS architecture and the reasoning behind each decision, addressing three core problems:

- **Seasonal downtime under load** (an estimated $80,000 in lost sales every Black Friday)
- **Slow, error-prone manual deployments** (4 hours per deployment, 3 production incidents this quarter caused by human error)
- **A 90-day window before the co-location contract renews**, which is the trigger for this migration

The target is a **three-tier architecture** (Web → Application → Database) that scales automatically, tolerates the failure of an entire Availability Zone, and supports fully automated deployments.

---

## Architecture Diagram

<img width="1322" height="742" alt="RetailEdge_arch" src="https://github.com/user-attachments/assets/b1c839f3-c88f-4c9a-b996-620c573e7671" />


---

## Web Tier

| Component | Role | Why we chose it |
|---|---|---|
| **Route 53** | DNS — routes requests to the nearest edge location | Fully managed DNS with built-in support for weighted routing, which we'll use for the final cutover during migration |
| **CloudFront** | CDN — caches static content close to the end user | Reduces load on the application tier and speeds up page loads, which matters most during traffic spikes like Black Friday |
| **Application Load Balancer (ALB)** | Distributes incoming requests across the application tier | A Layer 7 load balancer with health checks and path-based routing, spanning multiple Availability Zones automatically |

**Migration strategy:** Rehost. The existing Apache/PHP codebase doesn't need to change to run on EC2.

---

## Application Tier

| Component | Role | Why we chose it |
|---|---|---|
| **EC2 Auto Scaling Group** | Runs the application code, scales in/out based on load (min: 2, max: 10) | This directly solves the problem of handling 15,000 concurrent users on Black Friday, without paying for idle capacity the rest of the year |
| **Private Subnets (2 AZs)** | Application servers have no direct internet access | Improves security — instances have no public IP, and every request must pass through the ALB first |

**Migration strategy:** Replatform. We benefit from a managed Auto Scaling service instead of manually provisioning capacity, without rewriting the application itself.

---

## Database Tier

| Component | Role | Why we chose it |
|---|---|---|
| **RDS MySQL (Multi-AZ)** | Primary database | Same engine (MySQL) the application already uses, so the migration path is straightforward. Multi-AZ gives us synchronous replication to a standby in a second AZ, with automatic failover if the primary fails — no manual intervention required |
| **ElastiCache (Redis)** | Caching layer | Reduces load on the database by caching frequently requested query results, improving response times especially during peak traffic |
| **S3** | Static asset storage (images, CSS, JS) | Low-cost, highly available object storage that integrates directly with CloudFront |

**Migration strategy:** Replatform. Instead of self-managing MySQL on a server (patching, manual backups, etc.), we move to a fully managed service running the same engine.

---

## Network Design (VPC)

The infrastructure spans **two Availability Zones** for high availability. Each tier is isolated in its own subnet, following the principle of **least privilege**:

| Tier | AZ-a | AZ-b | Internet access |
|---|---|---|---|
| Public (Web) | 10.0.1.0/24 | 10.0.2.0/24 | Direct (via Internet Gateway) |
| Private (Application) | 10.0.11.0/24 | 10.0.12.0/24 | Indirect only (via NAT, if outbound updates are needed) |
| Database | 10.0.21.0/24 | 10.0.22.0/24 | None — no route to the Internet Gateway |

Each tier is isolated from the others using Security Groups that only allow traffic in one direction (ALB → App → Database). No tier can bypass the layer directly above it.

---

## Why Multi-AZ Everywhere?

The core design goal is that the system **survives the failure of an entire Availability Zone** without going down:

- The ALB spans both AZ-a and AZ-b
- The Auto Scaling Group runs instances in both AZs
- RDS Multi-AZ fails over automatically if the primary goes down
- ElastiCache has a standby replica ready to take over

This directly addresses the recurring Black Friday downtime problem.

---
