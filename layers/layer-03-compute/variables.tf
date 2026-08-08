variable "aws_region" { type = string default = "us-east-1" }
variable "project_name" { type = string default = "retailedge" }
variable "environment" { type = string default = "sandbox" }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "alb_security_group_id" { type = string }
variable "app_security_group_id" { type = string }
variable "golden_ami_id" { type = string description = "AMI containing the application runtime used by the launch template" }
variable "instance_type" { type = string default = "t3.small" }
variable "app_port" { type = number default = 8080 description = "Port exposed by the application on the EC2 instances" }
variable "health_check_path" { type = string default = "/" description = "HTTP path used by the ALB target group health check" }
variable "min_size" { type = number default = 2 }
variable "desired_capacity" { type = number default = 2 }
variable "max_size" { type = number default = 10 }
variable "target_cpu" { type = number default = 60 }
variable "enable_scheduled_scaling" { type = bool default = true }
variable "certificate_arn" { type = string default = null nullable = true }
