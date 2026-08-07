# Layer 01 — Network & Security Foundation

This layer creates the foundational AWS network for RetailEdge.

## Scope

- VPC: `10.0.0.0/16`
- Two Availability Zones
- 2 public subnets
- 2 private application subnets
- 2 isolated database subnets
- Internet Gateway
- Public, private, and database route tables
- Route table associations
- Tiered security groups for ALB, application, RDS, and Redis

## Sandbox cost decision

The sandbox profile intentionally does **not** create a NAT Gateway. The private and database route tables therefore have no default internet route.

This keeps Layer 01 focused on networking and avoids introducing an hourly NAT Gateway charge before the application actually requires outbound internet access from private subnets.

## Network layout

```text
                         Internet
                            |
                         Internet
                         Gateway
                            |
              +-------------+-------------+
              |                           |
        Public AZ-1                 Public AZ-2
              |                           |
             ALB                         ALB
              |                           |
        Private AZ-1                Private AZ-2
              |                           |
             App                         App
              \                           /
               \                         /
                +-----------------------+
                         |
                  Database Subnets
                    AZ-1 / AZ-2
```

## Security boundaries

```text
Internet
   |
 443
   v
ALB SG
   |
 8080
   v
App SG
   |
 +----------------+
 |                |
3306            6379
 |                |
v                v
RDS SG        Redis SG
```

The Redis security group is intentionally separate from the RDS security group.

## Before apply

Run from this directory:

```bash
terraform fmt -check
terraform init
terraform validate
terraform plan
```

Do **not** run `terraform apply` yet. The AWS account and Free Tier/credit limits should be checked before deployment.

## Expected outputs

The next layers will consume:

- `vpc_id`
- `public_subnet_ids`
- `private_subnet_ids`
- `database_subnet_ids`
- `alb_security_group_id`
- `app_security_group_id`
- `rds_security_group_id`
- `redis_security_group_id`

## Migration note

The original Terraform implementation remains under `terraform/` on this refactor branch for comparison. It should not be applied together with this layer because both configurations define overlapping network resources.
