# Go-Live Checklist

## Five checks before DNS cutover

1. ALB target group has healthy instances in the expected Availability Zones.
2. Application smoke tests pass for authentication, catalog, cart, checkout, and order flows.
3. RDS connectivity, backups, encryption, and migration validation are confirmed.
4. CloudWatch alarms are configured and their behavior has been validated.
5. The rollback revision, old environment, and DNS rollback procedure are ready.

## Safe DNS cutover

1. Lower the existing DNS TTL ahead of the migration window.
2. Start with a small Route 53 weighted record for the AWS environment.
3. Monitor ALB latency, 5xx errors, application logs, RDS health, and business smoke tests.
4. Increase the AWS weight gradually until it reaches 100%.
5. If a critical issue appears, set the old environment back to the dominant weight and investigate without destroying the old environment.
6. Keep the rollback environment until the agreed validation window closes.

## CI/CD note

The sandbox currently provisions GitHub Actions OIDC authentication and private S3 artifact storage. The application deployment mechanism is intentionally left separate until the application's build artifact and runtime deployment contract are defined.
