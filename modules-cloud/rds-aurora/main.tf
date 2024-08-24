# resource "aws_rds_cluster" "rds-cluster" {
#   engine                    = "aurora-mysql"
#   engine_version            = "8.0.mysql_aurora.3.02.1"
#   database_name             = "mydb"
#   master_username           = "admin"
#   master_password           = "adminadmin"
#   storage_type              = "gp3"
#   db_cluster_instance_class = "db.t3.medium"
#   allocated_storage         =  25
#   network_type              = "IPV4"

#   vpc_security_group_ids = [aws_security_group.rds_sg.id]
#   deletion_protection    = false

#   backup_retention_period         = 7
#   enabled_cloudwatch_logs_exports = ["error", "audit", "general"]

#   storage_encrypted = true



# }

# # Aurora Cluster Instance (Writer)
# resource "aws_rds_cluster_instance" "aurora_mysql_writer" {
#   identifier          = "aurora-cluster-instance-1"
#   cluster_identifier  = aws_rds_cluster.rds-cluster.id
#   instance_class      = "db.t3.medium" # Choose your instance class (e.g., memory-optimized)
#   engine              = aws_rds_cluster.rds-cluster.engine
#   publicly_accessible = false
# }

# # Additional Aurora Cluster Instance (Reader)
# resource "aws_rds_cluster_instance" "aurora_mysql_reader" {
#   identifier          = "aurora-cluster-instance-2"
#   cluster_identifier  = aws_rds_cluster.rds-cluster.id
#   instance_class      = "db.t3.medium"
#   engine              = aws_rds_cluster.rds-cluster.engine
#   publicly_accessible = false
# }


# resource "aws_security_group" "rds_sg" {
#   name        = "allow-mysql-access"
#   description = "Allow MySQL access"

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Replace with your allowed IP range for security
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
