# Network Notes

## Why do database subnets have no Internet Gateway route?

The database tier should not initiate or receive general internet traffic. Removing the Internet Gateway route reduces the attack surface and enforces the intended path: application instances access RDS through the RDS Security Group, while the database remains isolated from direct public access.

## Security Groups versus NACLs

Security Groups are stateful controls attached to network interfaces. A return packet is allowed automatically when the corresponding connection is allowed. NACLs are stateless subnet-level controls and require explicit inbound and outbound rules. RetailEdge uses Security Groups for the primary least-privilege boundaries; NACLs can be added as a separate defense-in-depth control when the security requirements justify the operational overhead.
