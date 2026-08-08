resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project_name}-${var.environment}-codedeploy-${data.aws_caller_identity.current.account_id}"

  tags = {
    Project     = "RetailEdge"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket                  = aws_s3_bucket.artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_codedeploy_app" "app" {
  name             = "${var.project_name}-${var.environment}"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "app" {
  app_name               = aws_codedeploy_app.app.name
  deployment_group_name  = "${var.project_name}-${var.environment}"
  service_role_arn       = aws_iam_role.codedeploy.arn
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  autoscaling_groups     = [var.autoscaling_group_name]

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
  }

  alarm_configuration {
    enabled                   = true
    alarms                    = [aws_cloudwatch_metric_alarm.high_latency.alarm_name, aws_cloudwatch_metric_alarm.high_error_rate.alarm_name]
    ignore_poll_alarm_failure = false
  }
}
