

#security_group

resource "aws_security_group" "security_group" {
  name        = "security_group"
  description = "Allow TLS inbound traffic - security group"

  dynamic "ingress" {
    for_each = var.port
    iterator = port
    content {
      description      = "TLS from VPC - security group"
      from_port        = port.value
      to_port          = port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "security_group"
  }
}