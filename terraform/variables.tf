# ============================================
# Variables for RetailEdge Project
# ============================================

variable "golden_ami_id" {
  description = "AMI ID for application instances"
  type        = string
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2 (us-east-1)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
