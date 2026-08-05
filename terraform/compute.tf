# ============================================
# Launch Template 
# ============================================
resource "aws_launch_template" "app" {
  name_prefix   = "retailedge-app-"
  image_id      = var.golden_ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Update system
    yum update -y

    # Install Apache, PHP, and MySQL client
    yum install -y httpd php php-mysqlnd mysql

    # Start Apache
    systemctl start httpd
    systemctl enable httpd

    # Create a simple test page
    echo "<?php phpinfo(); ?>" > /var/www/html/index.php

    # Install AWS CLI (optional)
    yum install -y awscli

    # Set up log directory
    mkdir -p /var/log/retailedge
    chown apache:apache /var/log/retailedge
    EOF
  )

  tags = {
    Name = "retailedge-app-instance"
  }
}

# ============================================
# Auto Scaling Group
# ============================================
resource "aws_autoscaling_group" "app" {
  name               = "retailedge-asg"
  vpc_zone_identifier = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  min_size         = 2
  max_size         = 10
  desired_capacity = 2

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  # Enable instance refresh for rolling updates
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
    }
  }

  # Health check configuration
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "retailedge-app-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "Production"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "RetailEdge"
    propagate_at_launch = true
  }
}

# ============================================
# Scaling Policy (Target Tracking)
# ============================================
resource "aws_autoscaling_policy" "cpu" {
  name                   = "retailedge-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.app.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}

# ============================================
# Scheduled Scaling (Bonus)
# ============================================
resource "aws_autoscaling_schedule" "friday_spike" {
  scheduled_action_name  = "friday-spike"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 6
  recurrence             = "0 20 * * 5"   # Every Friday at 8:00 PM UTC
  autoscaling_group_name = aws_autoscaling_group.app.name
}


# CloudWatch Alarm for High CPU 
# ============================================
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "retailedge-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This metric monitors EC2 CPU utilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  alarm_actions = [
    aws_autoscaling_policy.cpu.arn
  ]
}
