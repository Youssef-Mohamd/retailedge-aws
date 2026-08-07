variable "aws_region" { type = string default = "us-east-1" }
variable "project_name" { type = string default = "retailedge" }
variable "environment" { type = string default = "sandbox" }
variable "vpc_id" { type = string }
variable "database_subnet_ids" { type = list(string) }
variable "rds_security_group_id" { type = string }
variable "redis_security_group_id" { type = string }
variable "rds_instance_class" { type = string default = "db.t3.micro" }
variable "rds_multi_az" { type = bool default = false }
variable "rds_storage_gb" { type = number default = 20 }
variable "rds_backup_retention_days" { type = number default = 7 }
variable "db_name" { type = string default = "retailedge" }
variable "db_username" { type = string default = "retailedge_admin" }
variable "db_password" { type = string sensitive = true }
variable "redis_node_type" { type = string default = "cache.t3.micro" }
variable "redis_nodes" { type = number default = 1 }
variable "enable_redis" { type = bool default = true }
