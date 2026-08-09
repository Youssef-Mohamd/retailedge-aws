# GitHub OIDC Bootstrap

GitHub Actions should use OIDC rather than long-lived AWS access keys. GitHub requires the AWS account to trust the `token.actions.githubusercontent.com` OIDC provider and the workflow role should constrain the `sub` claim to this repository.

Before running the CI/CD workflow:

1. Create the GitHub OIDC provider in IAM with audience `sts.amazonaws.com`.
2. Apply Layer 5 so the GitHub Actions IAM role is created.
3. Set the repository variable `AWS_GITHUB_ROLE_ARN` to the Terraform output `github_actions_role_arn`.
4. Set the repository variables for the AWS region, CodeDeploy artifact bucket, CodeDeploy application, CodeDeploy deployment group, and `APP_PATH` when the application-specific deployment workflow is added.
5. Create a GitHub Environment named `production` and configure required reviewers.
6. Verify the environment is protected before allowing the deployment job to run.

The current architecture uses EC2/Auto Scaling + CodeDeploy for server-side deployment. Docker and Amazon ECR are intentionally not part of the deployment flow, so no ECR repository or ECR-related GitHub variable is required.

Do not store `AWS_ACCESS_KEY_ID` or `AWS_SECRET_ACCESS_KEY` in GitHub for this workflow.
