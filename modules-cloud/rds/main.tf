resource "aws_db_instance" "basic" {
  instance_class = "db.t3.micro"
  engine = "mysql"
  engine_version = "8.0"
  identifier = "myinstance"
  username = "admin"
  password = "adminadmin" #Greater than 8 charaters 
  storage_type = "gp2"
  allocated_storage = "20"

  publicly_accessible = false

  vpc_security_group_ids = [ aws_security_group.rds_sg.id ]

  backup_retention_period = 7

  multi_az = false

  enabled_cloudwatch_logs_exports = ["error", "audit", "general"]

  deletion_protection = false


#Need to delet RDS 

  skip_final_snapshot = false
  final_snapshot_identifier = false

}



resource "aws_security_group" "rds_sg" {
  name        = "allow-mysql-access"
  description = "Allow MySQL access"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your allowed IP range for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Read Replica instance


resource "aws_db_instance" "mysql_replica" {
  instance_class = "db.m5.large"
  replicate_source_db = aws_db_instance.basic.identifier
}