# Layer 2 — Network Foundation and Security

This layer implements the network portion of the assignment.

## Required CIDRs

- VPC: `10.0.0.0/16`
- Public: `10.0.1.0/24`, `10.0.2.0/24`
- Private: `10.0.11.0/24`, `10.0.12.0/24`
- Database: `10.0.21.0/24`, `10.0.22.0/24`

## Security boundaries

`ALB → App:8080 → RDS:3306` and `App → Redis:6379` are the only application data paths. The database subnets have no route to an Internet Gateway. Security Groups are stateful; NACLs are subnet-level stateless filters and are not required for the basic assignment.

## Sandbox choice

The private route table has no NAT route by default. This avoids an always-on NAT Gateway while the sandbox is being validated. Production can add a NAT Gateway when private instances need outbound internet access.

## Validation

Run:

```bash
terraform fmt -check
terraform init
terraform validate
terraform plan
```

Apply only after reviewing the plan and confirming the AWS account's current Free Plan/credit balance.
