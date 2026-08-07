# Layer 4 — Database Migration Plan

The production migration uses AWS DMS with Full Load followed by Change Data Capture (CDC). The sandbox does not create a DMS replication instance because it is a migration tool rather than a continuously required application dependency.

## Phase 1 — Full Load

DMS copies the existing MySQL data into RDS. The exact duration depends on source size, network throughput, table count, and DMS configuration, so it must be measured in a staging rehearsal rather than guessed.

## Phase 2 — CDC

After the full load completes, DMS captures ongoing source changes and applies them to RDS. Monitor replication latency and table validation throughout this phase.

## Phase 3 — Cutover

1. Announce the maintenance window and stop new writes to the old application.
2. Confirm source writes have drained.
3. Wait until DMS CDC latency is effectively zero and validation checks pass.
4. Run final row-count/checksum validation for critical tables.
5. Point the application configuration at RDS.
6. Run smoke tests for authentication, catalog, cart, checkout, and order reads/writes.
7. Shift production traffic using the planned DNS cutover.

The final lag threshold should be agreed during the rehearsal; the goal is no outstanding changes before the write switch.

## Phase 4 — Rollback

For the first 48 hours, retain the old environment and its database in a controlled read-only/rollback state. If a critical issue appears, stop writes on the new system, restore the application configuration to the old database, validate consistency, and reverse the DNS weighting. Do not destroy the old database until the rollback window is closed.

## RPO and RTO

- **RPO:** the maximum acceptable amount of data loss measured in time.
- **RTO:** the maximum acceptable time to restore service.

RDS Multi-AZ is the production database availability configuration. It is not a promise of zero application-level data loss during every failure scenario. The migration's practical RPO depends on CDC lag and the cutover procedure; the RTO depends on application validation and the failover/cutover mechanism. These values should be measured during a staging rehearsal before being committed as an SLA.
