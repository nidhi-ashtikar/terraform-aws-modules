

#Security Group - RDS

resource "aws_security_group" "sg_aurora" {
  name        = "aurora_cluster_sg_name"
  description = "Security group that is needed for the Aurora"
  vpc_id      = "vpc-0ee28ef9fb473f4c2"

}

resource "aws_security_group_rule" "aws_security_group_rule" {
  type              = "ingress"
  from_port         = 0
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_aurora.id
  source_security_group_id = aws_security_group.sg_aurora.id
}