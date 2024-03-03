
# Creating aws_db_subnet_group 



resource "aws_db_subnet_group" "my_db_subnet_group" {
  name = var.my-db-subnet-group
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB Subnet Group"
  }
}



#Creating RDS DateBase Cluster



resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = var.cluster_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period

  vpc_security_group_ids = [aws_security_group.sg_aurora.id]
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
} 


#Creating RDS DateBase Instance



resource "aws_rds_cluster_instance" "aurora_instance" {
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = var.instance_class
  engine             = var.engine_instance
  identifier         = var.identifier
}


