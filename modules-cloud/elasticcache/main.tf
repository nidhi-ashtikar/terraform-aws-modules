resource "aws_elasticache_cluster" "ec" {
  cluster_id           = "cluster"
  engine               = "redis"
  engine_version       = "7.1"
  port                 = 6379
  parameter_group_name = aws_elasticache_parameter_group.pg.id
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1

  security_group_ids = [aws_security_group.sg.id]
}

resource "aws_elasticache_parameter_group" "pg" {
  name        = "cache-para"
  family      = "redis2.8"
  description = "This is Parameter Group"
  parameter {
    name  = "activerehashing"
    value = "yes"
  }
}

resource "aws_security_group" "sg" {
  name = "redis-sg"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

