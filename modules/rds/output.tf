output "my_db_subnet_group" {
  value = aws_db_subnet_group.my_db_subnet_group.name
} 

output "sg_aurora" {
  value = aws_security_group.sg_aurora.id
} 

output "aurora_cluster" {
  value = aws_rds_cluster.aurora_cluster.id
}