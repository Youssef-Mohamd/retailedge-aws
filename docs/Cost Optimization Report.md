# 💰 Cost Optimization Report — RetailEdge Inc.

---

## 📊 AWS Pricing Calculator Estimate

### Screenshot 1: Service Breakdown

 <img width="1735" height="625" alt="Screenshot 2026-07-31 122500" src="https://github.com/user-attachments/assets/df160812-0728-48d4-855c-8a433b80c2ae" />


*Figure 1: Monthly cost breakdown per service from AWS Pricing Calculator*

### Screenshot 2: Total Estimate Summary

<img width="1830" height="542" alt="Screenshot 2026-07-31 122516" src="https://github.com/user-attachments/assets/b9aa1afb-add9-49ff-9c86-9b4a259e07d2" />


*Figure 2: Total monthly and annual cost estimate from AWS Pricing Calculator*

---

## 📋 Current Cost (On-Demand)

| Service | Monthly Cost |
| :--- | :--- |
| Amazon EC2 (2 × t3.small) | $74.50 |
| Amazon RDS for MySQL (db.t3.small, Multi-AZ) | $112.79 |
| Amazon S3 (100 GB Standard) | $3.65 |
| Elastic Load Balancing (ALB) | $615.03 |
| Amazon VPC (NAT Gateway × 2) | $206.10 |
| **Total Monthly Cost** | **$1,012.07** |
| **Total Annual Cost** | **$12,144.84** |

---

##  Optimized Cost (Reserved Instances)

| Service | On-Demand | Reserved (70% off) | Monthly Savings |
| :--- | :--- | :--- | :--- |
| EC2 | $74.50 | $22.35 | $52.15 |
| RDS | $112.79 | $33.84 | $78.95 |
| **Total** | **$187.29** | **$56.19** | **$131.10** |

**Annual Savings with Reserved Instances:** $1,573.20

---

##  S3 Optimization

| Current | Optimized |
| :--- | :--- |
| S3 Standard (100 GB) = $2.30 | S3 Intelligent-Tiering = ~$1.80 |

**Annual Savings:** ~$6

---

##  ALB Optimization

| Current | Optimized |
| :--- | :--- |
| ALB (500 req/sec) = $615.03 | ALB (200 req/sec) = ~$246.00 |

**Annual Savings:** ~$4,428

---

##  NAT Gateway Optimization

| Current | Optimized |
| :--- | :--- |
| 2 NAT Gateways = $206.10 | 1 NAT Gateway = ~$103.05 |

**Annual Savings:** ~$1,236

---

## 📊 Summary of Recommendations

| Recommendation | Annual Savings | Effort | Priority |
| :--- | :--- | :--- | :--- |
| **Reserved Instances** (EC2 + RDS) | $1,573 | Low | 🔴 High |
| **Reduce ALB LCUs** (200 req/sec) | $4,428 | Medium | 🔴 High |
| **Single NAT Gateway** | $1,236 | Medium | 🟡 Medium |
| **S3 Intelligent-Tiering** | $6 | Low | 🟢 Low |
| **AWS Compute Optimizer** | Variable | Low | 🟢 Low |
| **Total Potential Savings** | **~$7,243/year** | — | — |

---

## 📈 3-Year Projection with Optimization

| Scenario | Year 1 | Year 2 | Year 3 | Total |
| :--- | :--- | :--- | :--- | :--- |
| **On-Premises** | $18,000 | $18,000 | $18,000 | $54,000 |
| **AWS On-Demand** | $12,145 | $12,145 | $12,145 | $36,435 |
| **AWS Optimized** | ~$4,902 | ~$4,902 | ~$4,902 | **~$14,706** |

**Total 3-Year Savings vs On-Premises:** ~$39,294 (72.7%)

---

## 📊 Visual Summary

### Monthly Cost Breakdown
#### ALB ████████████████████████████████████████ $615.03 (60.8%)
#### NAT Gateway ████████████████████████ $206.10 (20.4%)
#### RDS ████████████████ $112.79 (11.1%)
#### EC2 ██████████ $74.50 (7.4%)
#### S3 █ $3.65 (0.4%)


### Cost Comparison Chart (Annual)

| Scenario | Annual Cost |
| :--- | :--- |
| On-Premises | $18,000 |
| AWS On-Demand | $12,145 |
| AWS Optimized | ~$4,902 |

---


##  Conclusion

| Metric | Value |
| :--- | :--- |
| **Current On-Premises Cost** | $18,000/year |
| **AWS On-Demand Cost** | $12,145/year |
| **AWS Optimized Cost** | ~$4,902/year |
| **Total Annual Savings** | **~$13,098 (72.7%)** |
| **Total 3-Year Savings** | **~$39,294** |

---
