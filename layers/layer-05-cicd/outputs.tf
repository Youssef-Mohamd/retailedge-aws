output "ecr_repository_url" { value = aws_ecr_repository.app.repository_url }
output "codedeploy_application_name" { value = aws_codedeploy_app.app.name }
output "codedeploy_deployment_group_name" { value = aws_codedeploy_deployment_group.app.deployment_group_name }
output "artifact_bucket_name" { value = aws_s3_bucket.artifacts.bucket }
output "github_actions_role_arn" { value = aws_iam_role.github_actions.arn }
output "alerts_topic_arn" { value = aws_sns_topic.alerts.arn }
