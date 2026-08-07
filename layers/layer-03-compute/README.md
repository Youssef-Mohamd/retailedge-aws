# Layer 3 — Compute and Auto Scaling

## Assignment configuration

Production-oriented configuration:

- Launch Template uses `var.golden_ami_id`.
- ASG min = 2, desired = 2, max = 10.
- Instance refresh keeps at least 90% healthy capacity.
- Target tracking uses `ASGAverageCPUUtilization` with a 60% target.
- Scheduled scaling raises desired capacity to 6 every Friday at 20:00 UTC when enabled.
- ALB health checks determine whether instances receive traffic.

## Sandbox configuration

Use min = 1, desired = 1, max = 2 to keep the environment small. The account's current Free Plan lists `t3.small` as an eligible EC2 type for accounts created on or after July 15, 2025, but the actual account eligibility and remaining credits must be checked before apply.

The sandbox should use a prebuilt Golden AMI because the application instances are private and the sandbox intentionally has no NAT Gateway by default.

## Scaling behavior

When average ASG CPU reaches the target, target tracking changes desired capacity. A new instance launches from the Launch Template, passes the health checks, becomes registered with the target group, and only then receives application traffic. Two production instances are the minimum so an instance or Availability Zone failure does not immediately remove all application capacity.
