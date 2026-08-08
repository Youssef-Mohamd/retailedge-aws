resource "aws_cloudwatch_metric_alarm" "high_latency" {
  alarm_name          = "${var.project_name}-${var.environment}-high-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  extended_statistic  = "p95"
  threshold           = 0.8
  treat_missing_data  = "notBreaching"
  alarm_description   = "ALB p95 latency is above 800 milliseconds for five minutes"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "high_error_rate" {
  alarm_name          = "${var.project_name}-${var.environment}-high-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_description   = "ALB 5xx rate is above one percent for five minutes"

  metric_query {
    id          = "error_rate"
    expression  = "100 * errors / requests"
    label       = "ALB 5xx percentage"
    return_data = true
  }

  metric_query {
    id          = "errors"
    return_data = false

    metric {
      metric_name = "HTTPCode_ELB_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = 300
      stat        = "Sum"

      dimensions = {
        LoadBalancer = var.alb_arn_suffix
      }
    }
  }

  metric_query {
    id          = "requests"
    return_data = false

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = 300
      stat        = "Sum"

      dimensions = {
        LoadBalancer = var.alb_arn_suffix
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "db_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-db-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"
  alarm_description   = "RDS CPU utilization is above 80 percent"

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "cache_hit_rate" {
  count               = var.enable_redis_alarm ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-low-cache-hit-rate"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  threshold           = 70
  treat_missing_data  = "notBreaching"
  alarm_description   = "ElastiCache hit rate is below 70 percent"

  metric_query {
    id          = "hit_rate"
    expression  = "100 * hits / (hits + misses)"
    label       = "Cache hit percentage"
    return_data = true
  }

  metric_query {
    id          = "hits"
    return_data = false

    metric {
      metric_name = "CacheHits"
      namespace   = "AWS/ElastiCache"
      period      = 300
      stat        = "Sum"

      dimensions = {
        ReplicationGroupId = var.redis_replication_group_id
      }
    }
  }

  metric_query {
    id          = "misses"
    return_data = false

    metric {
      metric_name = "CacheMisses"
      namespace   = "AWS/ElastiCache"
      period      = 300
      stat        = "Sum"

      dimensions = {
        ReplicationGroupId = var.redis_replication_group_id
      }
    }
  }
}
