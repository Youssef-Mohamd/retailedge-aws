# Layer 2 — Network Foundation and Security

This layer implements the network portion of the assignment.

## Required CIDRs

- VPC: `10.0.0.0/16`
- Public: `10.0.1.0/24`, `10.0.2.0/24`
- Private: `10.0.11.0/24`, `10.0.12.0/24`
- Database: `10.0.21.0/24`, `10.0.22.0/24`

## Network design

- Two Availability Zones are used for the public, private, and database tiers.
- Public subnets use the Internet Gateway route table.
- Private application subnets have no Internet Gateway or NAT route.
- Database subnets use an isolated route table with no internet route.
- NAT Gateway is not part of this project because it is not required by the assignment.

## Security boundaries

`ALB → App:8080 → RDS:3306` and `App → Redis:6379` are the application data paths. Security Groups enforce these boundaries. Database subnets do not have a route to an Internet Gateway. NACLs are not required for the basic assignment.

## Sandbox choice

The sandbox keeps the same subnet and security boundaries while avoiding unnecessary paid networking resources. No NAT Gateway or NAT Elastic IP is created.

## Validation

Run:

```bash
terraform fmt -check
terraform init
terraform validate
terraform plan
```

Apply only after reviewing the plan and confirming the AWS account's current Free Plan/credit balance.
