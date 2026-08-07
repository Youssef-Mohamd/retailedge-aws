variable "aws_region" {
  description = "AWS region for the RetailEdge sandbox deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "sandbox"
}

variable "vpc_cidr" {
  description = "CIDR block for the RetailEdge VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Two Availability Zones used by the network layer"
  type        = list(string)
  default     = []
}
