
# RDS Subnet Group (for Multi-AZ)
# ----------------------------------

resource "aws_db_subnet_group" "main" {
  name       = "retailedge-db-subnet-group"
  subnet_ids = [
    aws_subnet.database_a.id,
    aws_subnet.database_b.id
  ]

  tags = {
    Name = "retailedge-db-subnet-group"
  }
}


# RDS MySQL Instance (Multi-AZ)
# ----------------------------------

resource "aws_db_instance" "main" {
  identifier     = "retailedge-db"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.small"

  allocated_storage     = 100
  storage_type          = "gp3"
  storage_encrypted     = true
  backup_retention_period = 7

  db_name  = "retailedge"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az               = true
  publicly_accessible    = false
  skip_final_snapshot    = false

  tags = {
    Name = "retailedge-db"
  }
}

# ElastiCache Subnet Group
# ----------------------------------

resource "aws_elasticache_subnet_group" "main" {
  name       = "retailedge-cache-subnet-group"
  subnet_ids = [
    aws_subnet.database_a.id,
    aws_subnet.database_b.id
  ]
}

# ElastiCache Redis (for caching)
# ----------------------------------

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "retailedge-redis"
  description          = "Redis cache for RetailEdge"
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = "cache.t3.micro"
  num_node_groups      = 1
  replicas_per_node_group = 1

  subnet_group_name = aws_elasticache_subnet_group.main.name
  security_group_ids = [aws_security_group.rds.id]

  at_rest_encryption_enabled  = true
  transit_encryption_enabled  = true

  tags = {
    Name = "retailedge-redis"
  }
}
