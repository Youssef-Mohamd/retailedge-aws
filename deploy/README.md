# Deployment Bundle

The CodeDeploy revision is built by GitHub Actions. The workflow copies `appspec.yml`, the deployment scripts, and a generated `config.env` into a ZIP before uploading it to the Layer 5 artifact bucket.

The application source itself is intentionally not invented in this infrastructure repository. Set the GitHub Actions variable `APP_PATH` to the directory containing the real RetailEdge application and its `Dockerfile`.

The target container must listen on port 8080 because the ALB target group uses port 8080.

The Golden AMI used by the EC2 Launch Template must have:

- Docker
- AWS CLI
- CodeDeploy agent
- An OS compatible with the CodeDeploy agent

CodeDeploy requires `appspec.yml` at the root of the revision bundle.
