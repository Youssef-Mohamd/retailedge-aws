variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "retailedge"
}

variable "environment" {
  type    = string
  default = "sandbox"
}

variable "alb_arn_suffix" {
  type = string
}

variable "rds_instance_identifier" {
  type = string
}

variable "redis_replication_group_id" {
  type    = string
  default = ""
}

variable "enable_redis_alarm" {
  type    = bool
  default = false
}

variable "github_repository" {
  type        = string
  description = "GitHub owner/repository, for example Youssef-Mohamd/retailedge-aws"
}
