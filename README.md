# RetailEdge AWS Infrastructure

AWS migration and cloud infrastructure implementation for the RetailEdge three-tier application.

## Infrastructure layers

- Layer 1: Network & Security
- Layer 2: Compute & Auto Scaling
- Layer 3: Data & Migration
- Layer 4: Observability
- Layer 5: CI/CD & Go-Live

Infrastructure is organized by layer so each part can be reviewed, tested, and deployed independently.

## Environments

The Terraform configuration supports a cost-controlled sandbox deployment and a production-oriented configuration. Production architecture decisions are documented separately from the resources intended to run in the AWS sandbox.

## Repository structure

```text
retailedge-aws/
├── architecture/
├── layers/
│   ├── layer-01-network/
│   ├── layer-02-compute/
│   ├── layer-03-data/
│   ├── layer-04-observability/
│   └── layer-05-cicd/
├── environments/
│   ├── sandbox/
│   └── production/
├── scripts/
└── .github/workflows/
```

See each layer README for its resources, dependencies, variables, deployment notes, and validation steps.
