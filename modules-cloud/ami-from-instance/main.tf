
# #################### AWS EC2 - AMI - ##########################


# resource "aws_instance" "ami-server" {
#   ami           = data.aws_ami.aws_ami.id
#   instance_type = "t2.micro"
#   availability_zone = "us-east-1a"

#   user_data = <<-EOF
#     #!/bin/bash
#     yum update -y
#     yum install -y httpd
#     systemctl start httpd
#     systemctl enable httpd
#   EOF

#   tags = {
#     Name = "AMI-server"
#   }
# }

# resource "aws_ami_from_instance" "ami_AMI-server" {
#   name = "ami_AMI-serve"
#   source_instance_id = aws_instance.ami-server.id
#   description        = "An AMI of the AMI-server instance"


#   tags = {
#     Name = "AMI of the AMI-server"
#   }

# }



# resource "aws_instance" "ami-new-server" {
#   ami = aws_ami_from_instance.ami_AMI-server.id
#   instance_type = "t2.micro"
#   availability_zone = "us-east-1b"

#   tags={
#     Name = "ami-new-server"
#   }
# }

