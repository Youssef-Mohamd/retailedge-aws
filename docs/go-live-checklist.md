# 🚀 Go-Live Checklist — RetailEdge Inc.

##  Pre-Cutover Verification (5 Things)

### 1. EC2 Instances
- [ ] All instances in ASG are healthy
- [ ] ALB health checks are passing
- [ ] No errors in application logs

### 2. Database (RDS)
- [ ] RDS Multi-AZ is replicating
- [ ] Backups are running (last backup < 24 hours)
- [ ] Connection string is correct

### 3. Caching (ElastiCache)
- [ ] Redis is running (Primary + Replica)
- [ ] Cache hit rate > 70%
- [ ] Application is using Redis

### 4. SSL/TLS
- [ ] ACM certificate is issued
- [ ] ALB listener uses HTTPS (port 443)
- [ ] Certificate is attached to ALB

### 5. Monitoring
- [ ] CloudWatch alarms configured
- [ ] SNS notifications working
- [ ] Dashboard created

---

## 🔄 DNS Cutover (Route 53 Weighted Routing)

| Step | Action | Traffic % | Duration |
| :--- | :--- | :--- | :--- |
| 1 | Point traffic to AWS | 10% | 30 min |
| 2 | Monitor errors | 10% | 30 min |
| 3 | Increase traffic | 50% | 1 hour |
| 4 | Monitor errors | 50% | 1 hour |
| 5 | Full cutover | 100% | — |

---

##  Rollback Plan

### Immediate Rollback (< 15 min)
1. Point DNS back to On-Premises (100%)
2. Investigate the issue

### Delayed Rollback (< 48 hours)
1. Use DMS to sync data back
2. Point DNS back to On-Premises

---

## 🎯 Go/No-Go Decision

| Criteria | Status |
| :--- | :--- |
| All health checks passing | ⬜ |
| RDS Multi-AZ replicating | ⬜ |
| Cache hit rate > 70% | ⬜ |
| SSL certificate valid | ⬜ |
| Monitoring configured | ⬜ |

**Decision:** ⬜ GO / ⬜ NO-GO

---

## 📋 Post-Go-Live Monitoring (24 Hours)

- [ ] Monitor CloudWatch for errors
- [ ] Check RDS replication lag
- [ ] Verify cache hit rate
- [ ] Confirm no 5xx errors
- [ ] Check user feedback

---

*Status: ⬜ Ready for Launch*
