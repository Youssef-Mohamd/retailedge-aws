# 🏗️ RetailEdge Inc. — AWS Three-Tier Architecture & Cloud Migration

> **Solutions Architect Simulation — 5-Day Implementation Roadmap**

---

## 📌 Project Overview

RetailEdge Inc. is a mid-size e-commerce company with:

* 200,000 monthly active users
* Approximately 12,000 concurrent users during Black Friday
* 3 bare-metal servers running a LAMP stack
* 2–3 hours of downtime every Black Friday
* Approximately $80,000 in lost sales per major outage
* 4-hour manual deployment process
* 3 production incidents this quarter caused by deployment human error
* A co-location contract that expires in 90 days

The goal of this project is to design and implement a highly available, scalable, secure, and automated AWS architecture using a **Three-Tier Architecture**.

The target architecture will use:

* Amazon Route 53
* Amazon CloudFront
* Application Load Balancer
* Amazon EC2 Auto Scaling
* Amazon RDS for MySQL
* Amazon ElastiCache for Redis
* Amazon S3
* Amazon VPC
* AWS DMS
* Amazon ECR
* AWS CodeDeploy
* GitHub Actions
* Amazon CloudWatch
* Amazon SNS
* Terraform

---

# 🎯 Project Goals

By completing this project, I should be able to:

* Design a production-style AWS Three-Tier Architecture.
* Apply the AWS Well-Architected Framework.
* Understand and apply the 6 Rs of Cloud Migration.
* Design a secure multi-AZ VPC.
* Apply the Principle of Least Privilege.
* Write Terraform infrastructure code.
* Configure EC2 Auto Scaling.
* Configure ALB and health checks.
* Understand Golden AMI architecture.
* Configure RDS Multi-AZ.
* Understand AWS DMS Full Load and CDC migration.
* Design a low-downtime database migration.
* Understand RPO and RTO.
* Use ElastiCache to reduce database load.
* Build a CI/CD pipeline using GitHub Actions.
* Use OIDC instead of static AWS credentials.
* Push Docker images to Amazon ECR.
* Implement automated deployment and rollback.
* Configure CloudWatch monitoring and alarms.
* Perform a safe DNS cutover using Route 53 Weighted Routing.
* Analyze and optimize AWS costs.

---

# 📁 Final Project Structure

```text
retailedge-aws/
│
├── docs/
│   ├── architecture-design.md
│   ├── migration_plan.md
│   ├── notes.md
│   ├── go_live_checklist.md
│   └── cost_optimization.md
│
├── terraform/
│   ├── main.tf
│   ├── security_groups.tf
│   ├── compute.tf
│   ├── data.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
└── README.md
```

> `variables.tf` and `outputs.tf` are provided files and should not be modified unless explicitly required.

---

# 🗓️ 5-Day Execution Plan

---

# 🔵 DAY 1 — Architecture Design & Network Foundation

## 🎯 Day 1 Objectives

By the end of Day 1, I should understand:

* The business problems.
* The AWS Three-Tier Architecture.
* Why each AWS service was selected.
* AWS Regions and Availability Zones.
* VPC and CIDR blocks.
* Public, Private, and Database subnets.
* Route Tables.
* Internet Gateway.
* NAT Gateway concept.
* Security Groups.
* NACLs.
* The Principle of Least Privilege.

---

## TASK 1 — Analyze the Client Requirements

### Business Problems

Identify the client's main problems:

* Seasonal downtime.
* Lack of automatic scalability.
* Manual deployments.
* Human errors during deployments.
* Increasing infrastructure costs.
* Co-location contract expiration.
* Database migration risk.
* Need for high availability.

### Deliverable

Create:

```text
docs/architecture-design.md
```

Add a section:

```markdown
## Business Requirements
```

Document:

* 200,000 MAU.
* 12,000 peak concurrent users.
* Support Black Friday traffic.
* Eliminate seasonal downtime.
* Improve availability.
* Reduce deployment time.
* Reduce human errors.
* Migrate within 90 days.
* Protect customer and order data.
* Minimize database migration downtime.

---

# TASK 2 — Define Technical Requirements

Map every business problem to a technical requirement.

Example:

| Business Problem           | Technical Requirement | AWS Solution          |
| -------------------------- | --------------------- | --------------------- |
| Black Friday overload      | Automatic scaling     | EC2 Auto Scaling      |
| Traffic distribution       | Load balancing        | ALB                   |
| High availability          | Multi-AZ deployment   | Multiple AZs          |
| Static content performance | CDN                   | CloudFront            |
| Database management        | Managed database      | RDS                   |
| Database load              | Caching               | ElastiCache Redis     |
| Deployment errors          | CI/CD                 | GitHub Actions        |
| Safe deployment            | Automated rollback    | CodeDeploy            |
| Database migration         | Minimal downtime      | AWS DMS               |
| Network security           | Tier isolation        | VPC + Security Groups |
| File storage               | Object storage        | S3                    |

### Deliverable

Add:

```markdown
## Technical Requirements
```

and:

```markdown
## Requirements Mapping
```

to `architecture-design.md`.

---

# TASK 3 — Design the High-Level Architecture

Design the following request flow:

```text
Users
  |
  v
Route 53
  |
  v
CloudFront
  |
  v
Application Load Balancer
  |
  v
EC2 Auto Scaling Group
  |
  +----> ElastiCache Redis
  |
  +----> RDS MySQL Multi-AZ
  |
  +----> S3
```

Understand the responsibility of each service.

### Route 53

* DNS resolution.
* Domain routing.
* Weighted routing for migration cutover.

### CloudFront

* CDN.
* Static content caching.
* Reduced latency.
* Reduced load on application servers.

### ALB

* HTTP/HTTPS traffic distribution.
* Health checks.
* Routes traffic only to healthy instances.

### EC2 Auto Scaling

* Automatically adds/removes instances.
* Provides high availability.
* Handles traffic spikes.

### RDS

* Managed MySQL.
* Multi-AZ.
* Automated backups.
* Encryption.
* Automatic failover.

### ElastiCache Redis

* Caching frequently requested data.
* Reduces database load.
* Improves application response time.

### S3

* Static assets.
* User uploads.
* Object storage.

---

# TASK 4 — Create the Architecture Diagram

Create a detailed diagram using:

* draw.io
* Lucidchart
* PowerPoint

The diagram must show:

```text
AWS Region
│
└── VPC
    │
    ├── Availability Zone A
    │   ├── Public Subnet
    │   │   └── ALB
    │   │
    │   ├── Private Subnet
    │   │   └── EC2
    │   │
    │   └── Database Subnet
    │       └── RDS
    │
    └── Availability Zone B
        ├── Public Subnet
        │   └── ALB
        │
        ├── Private Subnet
        │   └── EC2
        │
        └── Database Subnet
            └── RDS
```

Also include:

* Route 53
* CloudFront
* Internet Gateway
* NAT Gateway concept
* ElastiCache
* S3
* Security Groups
* Traffic flow

---

# TASK 5 — Migration Strategy

Study the **6 Rs**:

* Rehost
* Replatform
* Refactor
* Repurchase
* Retire
* Retain

Choose a strategy for:

| Component   | Strategy   | Justification |
| ----------- | ---------- | ------------- |
| Web Server  | Replatform | Explain why   |
| Application | Replatform | Explain why   |
| Database    | Replatform | Explain why   |

Write your own reasoning.

---

# TASK 6 — AWS Well-Architected Framework

Review the five pillars:

1. Operational Excellence
2. Security
3. Reliability
4. Performance Efficiency
5. Cost Optimization

Map the architecture to each pillar.

Example:

```text
Security
- Private EC2 instances
- Isolated database subnets
- Security Groups
- IAM
- Encryption
```

---

# TASK 7 — TCO Analysis

Current on-premises cost:

```text
$18,000 / year
```

Calculate:

```text
3-Year On-Premises Cost
= $18,000 × 3
= $54,000
```

Use the AWS Pricing Calculator to estimate:

* EC2
* EBS
* ALB
* CloudFront
* Route 53
* RDS
* ElastiCache
* S3
* NAT Gateway
* Data Transfer
* CloudWatch

Document all assumptions:

* AWS Region
* Instance types
* Number of instances
* Hours per month
* RDS size
* Storage
* Data transfer
* Requests
* S3 storage

Create a 3-year comparison.

---

# 🟣 DAY 2 — VPC, Security & Terraform

## 🎯 Day 2 Objectives

Understand:

* VPC
* CIDR
* Subnets
* Route Tables
* Internet Gateway
* NAT Gateway
* Security Groups
* NACLs
* Terraform basics
* Terraform workflow

---

# TASK 8 — Understand CIDR

VPC:

```text
10.0.0.0/16
```

Public:

```text
10.0.1.0/24
10.0.2.0/24
```

Private:

```text
10.0.11.0/24
10.0.12.0/24
```

Database:

```text
10.0.21.0/24
10.0.22.0/24
```

Understand:

* What `/16` means.
* What `/24` means.
* How subnets fit inside the VPC.
* Why different CIDRs are used.
* Why each subnet belongs to one AZ.

---

# TASK 9 — Complete `main.tf`

Implement:

* AWS Provider
* VPC
* Public Subnets
* Private Subnets
* Database Subnets
* Internet Gateway
* Route Tables
* Route Table Associations

Required CIDRs:

```text
VPC:
10.0.0.0/16

Public:
10.0.1.0/24
10.0.2.0/24

Private:
10.0.11.0/24
10.0.12.0/24

Database:
10.0.21.0/24
10.0.22.0/24
```

---

# TASK 10 — Understand Public vs Private vs Database Subnets

### Public Subnet

Used for resources that need inbound internet connectivity through an Internet Gateway.

Example:

```text
ALB
```

### Private Subnet

Used for application resources that should not be directly accessible from the internet.

Example:

```text
EC2
```

### Database Subnet

Used for database resources that should be isolated from the internet.

Example:

```text
RDS
```

---

# TASK 11 — Security Groups

Create:

### `alb_sg`

Inbound:

```text
HTTPS 443
Source: 0.0.0.0/0
```

### `app_sg`

Inbound:

```text
TCP 8080
Source: alb_sg
```

### `rds_sg`

Inbound:

```text
TCP 3306
Source: app_sg
```

Architecture:

```text
Internet
   |
   | 443
   v
ALB SG
   |
   | 8080
   v
App SG
   |
   | 3306
   v
RDS SG
```

---

# TASK 12 — Explain Database Isolation

Answer:

> Why does the Database Subnet have no route to the Internet Gateway?

Explain:

* Database should not be internet-facing.
* Reduced attack surface.
* Least privilege.
* Database should only accept traffic from the application tier.

---

# TASK 13 — Security Groups vs NACLs

Explain:

| Security Groups                      | NACLs                                     |
| ------------------------------------ | ----------------------------------------- |
| Stateful                             | Stateless                                 |
| Resource-level                       | Subnet-level                              |
| Allow rules                          | Allow and Deny                            |
| Return traffic automatically allowed | Return traffic must be explicitly allowed |

---

# TASK 14 — Terraform Validation

Run:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
```

Verify:

```text
No syntax errors
No validation errors
```

Review the plan carefully.

Do not blindly apply resources.

---

# 🟢 DAY 3 — Compute & Auto Scaling

## 🎯 Day 3 Objectives

Understand:

* EC2
* AMI
* Golden AMI
* Launch Template
* ALB
* Target Groups
* Health Checks
* ASG
* Target Tracking
* Instance Refresh
* Scheduled Scaling

---

# TASK 15 — Understand Golden AMI

Understand the difference between:

```text
Manual Setup
```

and:

```text
Golden AMI
    |
    v
Launch Template
    |
    v
Auto Scaling Group
```

The AMI should contain:

* OS
* Web server
* Runtime
* Application dependencies
* Application configuration

---

# TASK 16 — Complete `compute.tf`

Create:

* Launch Template
* Auto Scaling Group
* Target Group
* ALB integration
* Health Checks

Use:

```text
var.golden_ami_id
```

ASG:

```text
min = 2
desired = 2
max = 10
```

---

# TASK 17 — Configure Instance Refresh

Configure:

```text
min_healthy_percentage = 90
```

Understand why rolling instance replacement is safer than replacing all instances simultaneously.

---

# TASK 18 — Configure Target Tracking

Metric:

```text
ASGAverageCPUUtilization
```

Target:

```text
60%
```

Understand:

```text
CPU increases
    |
    v
CloudWatch metric
    |
    v
Scaling policy
    |
    v
ASG launches new instance
    |
    v
Instance boots
    |
    v
Application starts
    |
    v
ALB health check
    |
    v
Healthy
    |
    v
Traffic starts
```

---

# TASK 19 — Answer Scaling Questions

Write in:

```text
docs/notes.md
```

Answer:

### Question 1

If CPU hits 60% on one instance, what happens?

Explain:

* Metric collection.
* ASG target tracking.
* Scaling decision.
* New instance launch.
* Health checks.
* Traffic registration.

### Question 2

When does a new instance receive traffic?

Explain:

* Instance launch time.
* Boot time.
* Application startup.
* ALB health check.
* Healthy state.

### Question 3

Why Min = 2 instead of Min = 1?

Explain:

* High availability.
* Fault tolerance.
* Multi-AZ.
* No single point of failure.

---

# TASK 20 — Bonus: Scheduled Scaling

Create a scheduled scaling action:

```text
Every Friday
8:00 PM UTC
Desired Capacity = 6
```

Explain why scheduled scaling can be useful when traffic patterns are predictable.

---

# TASK 21 — Validate Compute

Run:

```bash
terraform fmt
terraform validate
terraform plan
```

Review:

* Launch Template.
* ASG.
* Desired capacity.
* Min/Max.
* Scaling policy.
* Instance refresh.

---

# 🔴 DAY 4 — Data Layer & Migration

## 🎯 Day 4 Objectives

Understand:

* RDS
* Multi-AZ
* Encryption
* Backups
* ElastiCache
* Redis
* AWS DMS
* Full Load
* CDC
* Cutover
* RPO
* RTO

---

# TASK 22 — Complete `data.tf`

Configure RDS MySQL:

```text
Multi-AZ = true
storage_encrypted = true
backup_retention_period = 7
```

Use:

* DB subnet group.
* RDS security group.
* Database subnets.

---

# TASK 23 — Configure ElastiCache Redis

Configure:

* 2 nodes.
* Encryption at rest.
* Encryption in transit.
* Private subnets.
* Security group.

Understand:

```text
Application
    |
    v
Redis
    |
    +--> Cache Hit
    |
    +--> Cache Miss
            |
            v
           RDS
            |
            v
          Redis
```

---

# TASK 24 — Understand RDS Multi-AZ

Understand:

```text
Primary
   |
   | Synchronous Replication
   v
Standby
```

If primary fails:

```text
Primary
   X
   |
   v
Automatic Failover
   |
   v
Standby becomes Primary
```

Understand that Multi-AZ provides high availability and failover, not a replacement for backups.

---

# TASK 25 — Understand AWS DMS

Migration architecture:

```text
On-Prem MySQL
      |
      | Full Load
      v
RDS MySQL
      |
      | CDC
      v
Live Data Replication
```

Understand:

### Full Load

Copies existing data.

### CDC

Captures:

* INSERT
* UPDATE
* DELETE

and replicates ongoing changes.

---

# TASK 26 — Create Migration Plan

Create:

```text
docs/migration_plan.md
```

Include:

## Phase 1 — Full Load

DMS copies all existing data.

Document:

* Estimated migration duration.
* How duration will be estimated.
* Data volume.
* Network throughput.
* DMS instance sizing.

Do not invent an exact duration without assumptions.

---

## Phase 2 — CDC

DMS continuously replicates changes.

Monitor:

```text
Replication Lag
```

---

## Phase 3 — Cutover

Use an agreed acceptance threshold.

Example:

```text
Replication Lag < 5 seconds
```

Cutover steps:

1. Announce maintenance window.
2. Put application into read-only or maintenance mode.
3. Stop new writes.
4. Wait for CDC to catch up.
5. Verify replication lag.
6. Validate critical tables.
7. Validate row counts.
8. Validate data consistency.
9. Update application DB connection.
10. Perform smoke tests.
11. Resume application writes.
12. Monitor production.

Target:

```text
Downtime < 30 minutes
```

---

# TASK 27 — Rollback Plan

If a problem is discovered within 48 hours:

1. Stop application writes.
2. Switch application back to the original database.
3. Restore DNS/application configuration if required.
4. Validate original database.
5. Resume traffic.
6. Investigate the issue.
7. Preserve migration logs.
8. Reconcile any data changes carefully.

Document the limitations and data consistency considerations of rollback after writes have occurred on the new database.

---

# TASK 28 — RPO and RTO

Explain:

### RPO

How much data loss is acceptable?

### RTO

How much downtime is acceptable?

Document expected targets based on the architecture and assumptions.

Do not claim:

```text
RPO = 0
```

without explaining the exact mechanism that guarantees it.

Distinguish between:

* RDS Multi-AZ.
* RDS Backups.
* Point-in-Time Recovery.
* AWS DMS CDC.
* Disaster Recovery.

---

# TASK 29 — Bonus: Redis Cache Flow

Create a simple diagram:

```text
Client
  |
  v
Application
  |
  v
Redis
  |
  +---- Cache Hit ----> Return Data
  |
  +---- Cache Miss
            |
            v
           RDS
            |
            v
       Store in Redis
            |
            v
        Return Data
```

Explain:

* Cache Hit.
* Cache Miss.
* TTL.
* Cache invalidation.
* Stale data.
* Cache failure.

---

# TASK 30 — Validate Data Layer

Run:

```bash
terraform fmt
terraform validate
terraform plan
```

Review:

* RDS Multi-AZ.
* Encryption.
* Backup retention.
* DB subnet group.
* Security groups.
* ElastiCache nodes.
* Encryption settings.

---

# 🟡 DAY 5 — CI/CD, Monitoring & Go-Live

## 🎯 Day 5 Objectives

Understand:

* GitHub Actions.
* Docker.
* Amazon ECR.
* IAM.
* OIDC.
* CodeDeploy.
* Auto Rollback.
* CloudWatch.
* SNS.
* Route 53 Weighted Routing.
* Cost Optimization.

---

# TASK 31 — CI/CD Pipeline Design

Create:

```text
.github/workflows/deploy.yml
```

Pipeline:

```text
Git Push
   |
   v
Test
   |
   v
Build
   |
   v
Docker Image
   |
   v
Amazon ECR
   |
   v
Manual Approval
   |
   v
Production Deployment
   |
   v
Health Check
   |
   +---- Success
   |
   +---- Failure
             |
             v
          Rollback
```

---

# TASK 32 — Test Stage

Configure:

* Checkout repository.
* Install dependencies.
* Run unit tests.

If tests fail:

```text
Pipeline stops
```

---

# TASK 33 — Build Stage

Configure:

* Docker build.
* Tag image.
* Authenticate with ECR.
* Push image to ECR.

Understand:

```text
GitHub Actions
      |
      v
Docker Build
      |
      v
ECR
```

---

# TASK 34 — OIDC Authentication

Do not store static AWS credentials.

Understand:

```text
GitHub Actions
      |
      v
OIDC Token
      |
      v
AWS IAM Role
      |
      v
AWS Permissions
```

Use least-privilege IAM permissions.

---

# TASK 35 — Production Approval

Production deployment must require manual approval.

Understand why:

* Prevent accidental production deployment.
* Add human verification.
* Protect production environment.

---

# TASK 36 — Deployment & Rollback

Use CodeDeploy or the provided deployment mechanism.

Configure:

* Rolling deployment.
* Health checks.
* Automatic rollback.

Expected behavior:

```text
New Version
    |
    v
Deploy
    |
    v
Health Check
    |
    +---- Success
    |
    +---- Failure
             |
             v
       Automatic Rollback
             |
             v
      Previous Version
```

---

# TASK 37 — CloudWatch Alarms

Create the following monitoring plan:

| Alarm              | Metric               | Threshold         | Action           |
| ------------------ | -------------------- | ----------------- | ---------------- |
| High Latency       | ALB P95 Latency      | > 800ms for 5 min | SNS Notification |
| High Error Rate    | ALB 5xx Rate         | > 1%              | SNS Notification |
| DB CPU Spike       | RDS CPUUtilization   | > 80%             | SNS Notification |
| Low Cache Hit Rate | ElastiCache Hit Rate | < 70%             | SNS Notification |

Consider:

* Evaluation periods.
* Datapoints to alarm.
* Missing data behavior.
* SNS notifications.

---

# TASK 38 — CloudWatch Dashboard

Create a monitoring dashboard for:

### ALB

* Request count.
* P95 latency.
* 4xx.
* 5xx.
* Healthy hosts.
* Unhealthy hosts.

### EC2 / ASG

* CPU.
* Instance count.
* Scaling activity.

### RDS

* CPU.
* Connections.
* Free storage.
* Read latency.
* Write latency.

### Redis

* Cache hit rate.
* CPU.
* Memory.
* Connections.

---

# TASK 39 — Go-Live Checklist

Create:

```text
docs/go_live_checklist.md
```

Before DNS cutover verify:

1. Application health.
2. ALB healthy targets.
3. Database availability.
4. Database backup and restore readiness.
5. Security configuration.
6. Monitoring and alarms.
7. Logging.
8. CI/CD rollback readiness.
9. Load testing.
10. Data migration validation.

---

# TASK 40 — Route 53 Weighted Cutover

Use gradual traffic shifting.

Example:

```text
Step 1
Old = 90%
AWS = 10%
```

Then:

```text
Step 2
Old = 70%
AWS = 30%
```

Then:

```text
Step 3
Old = 10%
AWS = 90%
```

Finally:

```text
AWS = 100%
```

Monitor:

* 5xx errors.
* Latency.
* CPU.
* RDS.
* Redis.
* Application logs.
* Business metrics.

If problems occur:

```text
AWS = 0%
Old = 100%
```

---

# TASK 41 — Cost Optimization

Create:

```text
docs/cost_optimization.md
```

Analyze:

## RDS

Consider:

* Reserved Instances.
* Right-sizing.
* Storage optimization.

## EC2

Consider:

* Savings Plans.
* Right-sizing.
* Compute Optimizer.

## S3

Consider:

* S3 Intelligent-Tiering.
* Lifecycle policies.
* Delete unused objects.

## General

Analyze:

* NAT Gateway usage.
* Data transfer.
* CloudFront caching.
* Unused resources.
* EBS volumes.
* CloudWatch log retention.

---

# TASK 42 — Final Terraform Validation

Run:

```bash
terraform fmt
terraform validate
terraform plan
```

Confirm:

```text
0 validation errors
```

Review the plan for:

* Unexpected public resources.
* Incorrect subnet placement.
* Incorrect Security Group rules.
* Missing encryption.
* Incorrect scaling configuration.
* Incorrect RDS configuration.

---

# 🧪 FINAL ARCHITECTURE REVIEW

Before considering the project complete, explain the entire architecture without looking at the documentation.

---

## Question 1

Why did we choose AWS?

---

## Question 2

Why do we use multiple Availability Zones?

---

## Question 3

Why is the ALB in public subnets?

---

## Question 4

Why are EC2 instances in private subnets?

---

## Question 5

Why is RDS in database subnets?

---

## Question 6

Why does RDS not have direct internet access?

---

## Question 7

What is the traffic flow from the user to the application?

```text
User
↓
Route 53
↓
CloudFront
↓
ALB
↓
EC2
↓
Redis / RDS / S3
```

---

## Question 8

What happens when an EC2 instance fails?

---

## Question 9

What happens when CPU reaches 60%?

---

## Question 10

Why is ASG Min = 2?

---

## Question 11

What happens if an Availability Zone fails?

---

## Question 12

Why use RDS Multi-AZ?

---

## Question 13

What is the difference between Multi-AZ and Read Replicas?

---

## Question 14

Why use ElastiCache?

---

## Question 15

What happens during a Cache Miss?

---

## Question 16

What is the difference between RPO and RTO?

---

## Question 17

How do we migrate 8 years of MySQL data with minimal downtime?

---

## Question 18

What is Full Load?

---

## Question 19

What is CDC?

---

## Question 20

How do we know when to perform the database cutover?

---

## Question 21

What is the rollback strategy?

---

## Question 22

Why use GitHub OIDC instead of static AWS credentials?

---

## Question 23

What happens if a deployment fails?

---

## Question 24

How do we detect production issues?

---

## Question 25

How do we safely migrate DNS?

---

## Question 26

How can we reduce AWS costs?

---

# 🏆 Final Deliverables Checklist

## Layer 1 — Architecture

* [ ] Business Requirements
* [ ] Technical Requirements
* [ ] Requirements Mapping
* [ ] Architecture Diagram
* [ ] Migration Strategy
* [ ] 6 Rs Analysis
* [ ] Well-Architected Analysis
* [ ] TCO Calculation
* [ ] 3-Year Cost Projection

---

## Layer 2 — Network

* [ ] VPC
* [ ] Public Subnets
* [ ] Private Subnets
* [ ] Database Subnets
* [ ] Internet Gateway
* [ ] Route Tables
* [ ] Route Table Associations
* [ ] ALB Security Group
* [ ] Application Security Group
* [ ] RDS Security Group
* [ ] Least Privilege Rules
* [ ] Security Groups vs NACLs Explanation
* [ ] Terraform Validate
* [ ] Terraform Plan

---

## Layer 3 — Compute

* [ ] Launch Template
* [ ] Golden AMI
* [ ] Auto Scaling Group
* [ ] Min = 2
* [ ] Desired = 2
* [ ] Max = 10
* [ ] ALB
* [ ] Target Group
* [ ] Health Checks
* [ ] Target Tracking
* [ ] CPU Target = 60%
* [ ] Instance Refresh
* [ ] Scheduled Scaling Bonus
* [ ] Scaling Questions
* [ ] Terraform Plan

---

## Layer 4 — Data

* [ ] RDS MySQL
* [ ] Multi-AZ
* [ ] Encryption at Rest
* [ ] Backup Retention = 7 days
* [ ] DB Subnet Group
* [ ] RDS Security Group
* [ ] ElastiCache Redis
* [ ] 2 Nodes
* [ ] Encryption at Rest
* [ ] Encryption in Transit
* [ ] DMS Full Load
* [ ] DMS CDC
* [ ] Replication Lag Monitoring
* [ ] Cutover Plan
* [ ] Rollback Plan
* [ ] RPO
* [ ] RTO
* [ ] Cache Hit/Miss Diagram
* [ ] Terraform Plan

---

## Layer 5 — CI/CD & Go-Live

* [ ] GitHub Actions
* [ ] Unit Tests
* [ ] Docker Build
* [ ] ECR Push
* [ ] OIDC Authentication
* [ ] IAM Role
* [ ] Manual Production Approval
* [ ] CodeDeploy
* [ ] Rolling Deployment
* [ ] Automatic Rollback
* [ ] CloudWatch Alarms
* [ ] SNS Notifications
* [ ] CloudWatch Dashboard
* [ ] Go-Live Checklist
* [ ] Route 53 Weighted Routing
* [ ] DNS Cutover Plan
* [ ] Rollback Plan
* [ ] Cost Optimization Report

---

# 🔐 Security Checklist

Before finalizing the project:

* [ ] No AWS credentials committed to Git.
* [ ] No hardcoded secrets.
* [ ] No public RDS access.
* [ ] No direct public access to EC2.
* [ ] Security Groups follow least privilege.
* [ ] Database traffic only allowed from App SG.
* [ ] Application traffic only allowed from ALB SG.
* [ ] HTTPS is used for public traffic.
* [ ] RDS encryption is enabled.
* [ ] Redis encryption is enabled.
* [ ] IAM follows least privilege.
* [ ] GitHub Actions uses OIDC.
* [ ] Production deployment requires approval.

---

# 💰 Cost Safety Checklist

Before using `terraform apply`:

* [ ] Review AWS Pricing Calculator.
* [ ] Enable AWS Budget.
* [ ] Configure Billing Alerts.
* [ ] Check NAT Gateway costs.
* [ ] Check RDS costs.
* [ ] Check ElastiCache costs.
* [ ] Check ALB costs.
* [ ] Check CloudFront costs.
* [ ] Check data transfer costs.
* [ ] Delete unused resources.
* [ ] Avoid leaving expensive resources running unnecessarily.

For this assignment, prefer:

```text
terraform plan
```

when actual deployment is not required.

---

# 📚 Recommended Learning Order

Before implementing each layer, review only the concepts needed for that layer.

### Day 1

```text
AWS Fundamentals
↓
Three-Tier Architecture
↓
Well-Architected Framework
↓
6 Rs
↓
TCO
```

### Day 2

```text
VPC
↓
CIDR
↓
Subnets
↓
Routing
↓
IGW / NAT
↓
Security Groups
↓
NACLs
↓
Terraform
```

### Day 3

```text
EC2
↓
AMI
↓
Launch Template
↓
ALB
↓
Target Groups
↓
Health Checks
↓
ASG
↓
Scaling
```

### Day 4

```text
RDS
↓
Multi-AZ
↓
Backups
↓
Redis
↓
DMS
↓
Full Load
↓
CDC
↓
RPO / RTO
```

### Day 5

```text
GitHub Actions
↓
Docker
↓
ECR
↓
OIDC
↓
CodeDeploy
↓
CloudWatch
↓
SNS
↓
Route 53 Weighted Routing
↓
Cost Optimization
```

---

# 🏁 Definition of Done

The RetailEdge project is considered complete when:

1. The architecture is clearly documented.
2. Every AWS service has a justified reason for being used.
3. The Three-Tier Architecture is correctly designed.
4. The VPC provides public, private, and isolated database tiers.
5. Security Groups enforce least privilege.
6. Terraform code passes validation.
7. Terraform plan completes successfully.
8. EC2 Auto Scaling is correctly configured.
9. RDS Multi-AZ is configured.
10. Redis caching is designed.
11. DMS migration and cutover are documented.
12. RPO and RTO are clearly explained.
13. CI/CD pipeline is documented and implemented.
14. OIDC is used instead of static AWS credentials.
15. Automated rollback is configured.
16. CloudWatch monitoring is defined.
17. Go-Live and rollback procedures are documented.
18. Cost optimization opportunities are identified.
19. All bonus tasks are attempted.
20. I can explain the complete architecture and defend every major architectural decision.

---

# 🎓 Final Goal

The final goal is not simply to complete Terraform files.

The goal is to be able to explain:

> **"Here is the business problem, here is the architecture I designed, here is why I selected each AWS service, here is how the traffic flows, here is how the system scales, here is how the database is protected and migrated, here is how deployments are automated, here is how failures are detected and rolled back, and here is how I control the cost."**

This project should be treated as a **Solutions Architect case study**, not only as a Terraform exercise.
