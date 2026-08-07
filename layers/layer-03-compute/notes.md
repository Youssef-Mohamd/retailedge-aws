# Compute Notes

## What happens when CPU reaches the 60% target?

1. CloudWatch publishes ASG CPU metrics.
2. Target tracking evaluates the configured 60% target.
3. If capacity is insufficient, Auto Scaling increases desired capacity within the configured min/max bounds.
4. EC2 launches an instance from the Launch Template.
5. The instance becomes healthy and registers with the target group.
6. The ALB health check succeeds before the instance receives production traffic.
7. Target tracking continues adjusting capacity as demand changes.

## Why does the new instance not receive traffic immediately?

The ALB only sends traffic to registered healthy targets. The new instance must boot, start the application, register with the target group, and pass the configured health checks.

## Why is production min set to 2 instead of 1?

Two instances provide baseline redundancy. If one instance fails or an Availability Zone becomes unavailable, the other instance can continue serving traffic while Auto Scaling replaces capacity. A minimum of one would make the application dependent on a single instance during the failure window.

## Instance refresh

The 90% minimum healthy percentage allows rolling replacement of instances when the Launch Template changes without intentionally taking the whole application tier offline.
