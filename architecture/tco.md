# RetailEdge TCO

The original project estimate used the following on-premises baseline:

- On-premises: **$18,000/year**
- Three-year baseline: **$54,000**

The earlier AWS estimate in the project used an on-demand architecture containing EC2, RDS Multi-AZ, S3, ALB, and two NAT Gateways. That estimate should be treated as a planning estimate, not a current AWS bill.

## Sandbox versus Production

The sandbox intentionally does not reproduce every production cost driver. It disables NAT Gateway by default, uses a Single-AZ RDS instance, keeps the Auto Scaling range small, and uses one Redis node when the sandbox credit balance supports it.

## Cost optimization recommendations

1. Use Savings Plans or Reserved Instances only after usage is stable.
2. Use S3 Intelligent-Tiering when the access pattern justifies it.
3. Review AWS Compute Optimizer recommendations before changing instance sizes.
4. Avoid always-on NAT Gateways in environments that do not need outbound internet access.
5. Destroy sandbox resources after validation.

AWS Free Plan credits are finite. The sandbox configuration is designed to reduce burn rate rather than claim that every resource is permanently free.
