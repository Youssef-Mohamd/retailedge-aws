output "rds_endpoint" {
  value = aws_db_instance.mysql.address
}

output "rds_port" {
  value = aws_db_instance.mysql.port
}

output "redis_primary_endpoint" {
  value = var.enable_redis ? aws_elasticache_replication_group.redis[0].primary_endpoint_address : null
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}
