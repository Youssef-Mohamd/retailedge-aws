variable "aws_region" {
  type        = string
  description = "AWS region for the environment"
  default     = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "retailedge"
}

variable "environment" {
  type    = string
  default = "sandbox"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnets" {
  type    = list(string)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "allow_http_for_sandbox" {
  type        = bool
  description = "Allow HTTP to the ALB when the sandbox has no ACM certificate"
  default     = true
}
