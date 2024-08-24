# ######################################   AWS EC2 - ELASTIC IP ##########################33

# resource "aws_eip" "lb" {
#   vpc = true 

#   tags = {
#     Name = "fluffy-eip"
#   }
# }

# resource "aws_instance" "server" {
#   ami           = data.aws_ami.aws_ami.id
#   instance_type = "t2.micro"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "fluffy-server"
#   }
# }

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.server.id
#   allocation_id = aws_eip.lb.id
# }