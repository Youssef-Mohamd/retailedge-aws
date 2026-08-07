# Environments

Each layer is an independent Terraform root so the project can be reviewed and applied in sequence.

## Order

1. Layer 2 — Network
2. Layer 3 — Compute
3. Layer 4 — Data
4. Layer 5 — CI/CD and monitoring

Layer 1 is documentation and does not have a Terraform state.

## Sandbox

Use the example tfvars files as templates. After applying a layer, copy the required outputs into the next layer's local tfvars file. Keep real `.tfvars` files out of Git.

The sandbox profile is intentionally smaller than the production architecture: no NAT Gateway by default, RDS Single-AZ, and a small ASG. Do not enable a service just because the architecture diagram contains it; verify the account's current Free Plan eligibility and credit balance first.
