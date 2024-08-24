###### Load Balancer 

# resource "aws_lb" "nlb" {
#   name               = "nalb"
#   load_balancer_type = "network"
#   ip_address_type    = "ipv4" # Use "dualstack" if you need both IPv4 and IPv6
#   security_groups    = [aws_security_group.nlbsg.id]
#   subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
#   enable_cross_zone_load_balancing = true #Default False

# }


# ####### security_group for Load Balancer 

# resource "aws_security_group" "nlbsg" {
#   name   = "mlbsg"
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "nlbsg"
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # ####### Load Balancer - Target Group 

# resource "aws_lb_target_group" "n-target-group" {
#   name     = "ntg"
#   port     = 80
#   protocol = "TCP"
#   vpc_id   = aws_vpc.vpc.id

#   health_check {
#     protocol          = "HTTP"
#     healthy_threshold = 2
#     timeout           = 2
#     interval          = 5
#   }
# }

# #target_type = instance (Default ) /  Ip  / lambda / Application Load Balancer 


# # ####### Load Balancer - Listner


# resource "aws_lb_listener" "nlb-listener" {
#   load_balancer_arn = aws_lb.nlb.arn
#   port              = 80
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.n-target-group.arn
#   }

# }

# # ####### Load Balancer - target group attachment 

# resource "aws_lb_target_group_attachment" "ntg-attachment" {
#   count            = 2
#   target_group_arn = aws_lb_target_group.n-target-group.arn
#   target_id        = aws_instance.instance[count.index].id
# }



# ####### EC2



# resource "aws_instance" "instance" {
#   count                  = 2
#   ami                    = data.aws_ami.aws_ami.id
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.sg.id]
#   subnet_id              = aws_subnet.public-subnet-1.id


#   user_data = <<-EOF
#     #!/bin/bash
#     sudo yum update -y
#     sudo yum install -y httpd
#     sudo systemctl start httpd
#     sudo systemctl enable httpd
#     echo "Hello from Instance ${count.index}" > /var/www/html/index.html

# EOF   

#   tags = {
#     Name = "instance-${count.index}"
#   }

# }




# ####### security_group for Load Balancer 

# resource "aws_security_group" "sg" {
#   name   = "sg"
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "sg"
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


# output "alb_dns_name" {
#   value = aws_lb.nlb.dns_name
# }
