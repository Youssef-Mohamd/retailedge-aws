# 📝 Q&A Notes — RetailEdge AWS Migration

---

##  Layer 2 — Network Foundation & Security

### Task 2.3 — Questions & Answers

---

#### 1. Why does the Database Subnet have no route to the Internet Gateway?

**Answer:**

The Database Subnet has no route to the Internet Gateway for **security reasons** (Principle of Least Privilege).

- The database contains sensitive customer data (orders, payments, personal information).
- If the subnet had a route to the IGW, it would be accessible from the internet.
- This would expose it to potential attacks (SQL injection, DDoS, brute force).
- By keeping it in an **isolated subnet** with no internet route, only the EC2 instances in the Private Subnet (App Tier) can access the database.
no public access.

---

#### 2. What is the difference between Security Groups and NACLs?

| Feature | **Security Group** | **NACL** |
| :--- | :--- | :--- |
| **Stateful?** |  Stateful — remembers connections |  Stateless — does not remember |
| **Level** | Instance-level (attached to EC2) | Subnet-level (attached to entire subnet) |
| **Rules** | Allow rules only | Allow + Deny rules |
| **Evaluation** | All rules evaluated | Evaluated by number (lowest first) |
| **Default** | Inbound: Deny, Outbound: Allow | Inbound: Deny, Outbound: Allow |

- **Security Group** = Security guard at each apartment door .
- **NACL** = Metal detector at building entrance (checks everyone every time).

---

##  Layer 3 — Compute & Auto Scaling

### Task 3.3 — Questions & Answers

---

#### 1. If CPU hits 60% on one instance, what happens next — step by step?

| Step | Action |
| :--- | :--- |
| 1 | CloudWatch Alarm detects CPU > 60% |
| 2 | Auto Scaling Group decides to add a new instance |
| 3 | AWS provisions a new EC2 instance (takes ~2-3 minutes) |
| 4 | New instance starts and runs User Data script |
| 5 | ALB Health Checks verify the instance is ready |
| 6 | New instance begins receiving traffic |

---

#### 2. When does a new instance start receiving traffic? Why not immediately?

**Answer:**

The new instance starts receiving traffic **after the ALB Health Checks pass** (typically 30-60 seconds after the instance is ready).

**Why not immediately?**
- The application needs time to initialize (install dependencies, start services).
- If it received traffic before being ready, it would return errors to users.
- ALB Health Checks ensure the instance is **fully functional** before routing traffic.


---

#### 3. Why did we choose `min=2` instead of `min=1`?

**Answer:**

For **High Availability** (fault tolerance).

| Why `min=1` is risky | Why `min=2` is better |
| :--- | :--- |
| If the single instance fails, the entire site goes down | If one instance fails, the other keeps running |
| Cannot perform updates without downtime | Can perform rolling updates (zero downtime) |
| If AZ-a fails, site is down | If AZ-a fails, AZ-b keeps running |

 A plane with 2 engines — if one fails, the other keeps flying.

---

### Task 3.4 — Bonus: Scheduled Scaling

**Question:** Write a Scheduled Scaling Action that increases desired capacity to 6 every Friday at 8:00 PM UTC.

**Answer:**

```hcl
# ============================================
# Scheduled Scaling (Bonus)
# ============================================
resource "aws_autoscaling_schedule" "friday_spike" {
  scheduled_action_name  = "friday-spike"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 6
  recurrence             = "0 20 * * 5"   # Every Friday at 8:00 PM UTC
  autoscaling_group_name = aws_autoscaling_group.app.name
}
```

Why Friday at 8:00 PM UTC?

Friday is the start of the weekend — traffic spikes (shopping, entertainment).

8:00 PM UTC is evening in Europe and afternoon in US — peak shopping hours.

This ensures the system is ready before the traffic increase.


---

## Task 4.3 — Questions & Answers

---

### 1. What is the difference between RPO and RTO?

| Term | Full Form | Definition | Analogy |
| :--- | :--- | :--- | :--- |
| **RPO** | Recovery Point Objective | How much data you can afford to lose (measured in time) | If you lose your wallet, how much money can you afford to lose? |
| **RTO** | Recovery Time Objective | How long you can afford to be down (measured in time) | How long can you afford to be without your wallet before getting a replacement? |

**Example:**
- If server crashes at **10:00 AM**
- Last backup was at **9:55 AM**
- Server is back online at **10:05 AM**

| Metric | Value |
| :--- | :--- |
| **RPO** | 5 minutes (data from 9:55 to 10:00 is lost) |
| **RTO** | 5 minutes (downtime from 10:00 to 10:05) |

---

### 2. Based on the configuration you built, what are the expected RPO and RTO values?

| Metric | Target | How We Achieve It |
| :--- | :--- | :--- |
| **RPO** | **< 5 minutes** | **Automated Backups** — RDS takes snapshots every 5 minutes with 7-day retention |
| **RTO** | **< 5 minutes** | **Multi-AZ Automatic Failover** — If Primary fails, Standby takes over in 60-120 seconds |

**Configuration Used:**

```hcl
resource "aws_db_instance" "main" {
  backup_retention_period = 7          # RPO: backups stored for 7 days
  multi_az               = true        # RTO: automatic failover in 60-120 seconds
  storage_encrypted      = true        # Security: data encrypted at rest
}
```
                    RPO (< 5 min)                    RTO (< 5 min)
                    ──────────────                   ──────────────
                         │                                │
                         ▼                                ▼
              ┌─────────────────┐              ┌─────────────────┐
              │  Automated      │              │  Multi-AZ       │
              │  Backups        │              │  Failover       │
              │  (every 5 min)  │              │  (60-120 sec)   │
              └─────────────────┘              └─────────────────┘
                         │                                │
                         ▼                                ▼
              ┌─────────────────┐              ┌─────────────────┐
              │  Data Loss      │              │  Downtime       │
              │  < 5 minutes    │              │  < 5 minutes    │
              └─────────────────┘              └─────────────────┘

```
         

        
