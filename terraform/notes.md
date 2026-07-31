# 🟣 Layer 2 — Network Foundation & Security

## 📋 Task 2.1 — Complete CIDR Ranges

### VPC & Subnet Layout

| Subnet Type | AZ-a | AZ-b |
| :--- | :--- | :--- |
| **Public** (Web/ALB) | `10.0.1.0/24` | `10.0.2.0/24` |
| **Private** (App/EC2) | `10.0.11.0/24` | `10.0.12.0/24` |
| **Database** (RDS) | `10.0.21.0/24` | `10.0.22.0/24` |

**VPC CIDR:** `10.0.0.0/16`

---

## 🤔 Why These CIDR Ranges?

| Choice | Why? |
| :--- | :--- |
| **VPC /16** | Gives us 65,536 IPs — plenty of room to grow |
| **Subnets /24** | Each subnet gets 256 IPs — enough for 200+ EC2 instances per AZ |
| **Separate subnets per AZ** | High Availability — if one AZ fails, the other keeps running |
| **Public vs Private vs Database** | Security layers — different tiers have different access needs |

---

## 📝 Task 2.2 — Security Groups

### Security Group Rules

| Security Group | Inbound Rules | Why? |
| :--- | :--- | :--- |
| **`alb_sg`** | HTTPS (443) from `0.0.0.0/0` | Users access the site via HTTPS |
| **`app_sg`** | Port 8080 from `alb_sg` only | EC2 should ONLY accept traffic from ALB — not directly from internet |
| **`rds_sg`** | Port 3306 from `app_sg` only | Database should ONLY accept traffic from EC2 — nothing else |

---

## 📝 Task 2.3 — Explanation for Sarah (CTO)

### 1. Why does the Database Subnet have no route to the Internet Gateway?

**Simple Answer:** For **security**.

The database stores customer orders and payment data. If it had internet access, hackers could try to attack it directly. By keeping it **isolated**, only our EC2 instances can reach it.

**Think of it like:** A bank vault in the basement — only authorized staff can enter, no public access.

---

### 2. What is the difference between Security Groups and NACLs?

| Feature | **Security Group** | **NACL** |
| :--- | :--- | :--- |
| **Stateful?** | ✅ Yes — remembers connections | ❌ No — checks every packet |
| **Level** | Instance-level (attached to EC2) | Subnet-level (attached to entire subnet) |
| **Rules** | Allow only | Allow + Deny |
| **Order** | All rules applied | Rules evaluated by number (lowest first) |

**Simple Analogy:**
- **Security Group** = Security guard at each apartment door (remembers you).
- **NACL** = Metal detector at building entrance (checks everyone every time).

---

## 📁 Files Created

| File | What It Does |
| :--- | :--- |
| `main.tf` | Defines VPC, 6 subnets, Internet Gateway, and route tables |
| `security_groups.tf` | Defines 3 security groups (ALB, App, RDS) |

---

## 🧠 Key Takeaways — Layer 2

| Concept | What It Means |
| :--- | :--- |
| **VPC** | Our private network in AWS |
| **Public Subnet** | For ALB — accessible from internet |
| **Private Subnet** | For EC2 — NOT directly accessible |
| **Database Subnet** | For RDS — completely isolated |
| **Security Groups** | Firewall at instance level (stateful) |
| **NACLs** | Firewall at subnet level (stateless) |
| **Principle of Least Privilege** | Only allow what's necessary, deny everything else |

---

## 📊 CIDR Allocation Summary

| Subnet | CIDR | Internet Access? |
| :--- | :--- | :--- |
| **Public A** | `10.0.1.0/24` | ✅ Yes (via IGW) |
| **Public B** | `10.0.2.0/24` | ✅ Yes (via IGW) |
| **Private A** | `10.0.11.0/24` | ❌ No (via NAT only) |
| **Private B** | `10.0.12.0/24` | ❌ No (via NAT only) |
| **Database A** | `10.0.21.0/24` | ❌ No (completely isolated) |
| **Database B** | `10.0.22.0/24` | ❌ No (completely isolated) |

---

## 🔗 How Traffic Flows
User → Internet → ALB (Public Subnet)

ALB → EC2 (Private Subnet) on Port 8080

EC2 → RDS (Database Subnet) on Port 3306
