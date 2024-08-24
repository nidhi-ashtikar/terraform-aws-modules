
####### security_group for Load Balancer 

resource "aws_security_group" "lbsg" {
  name   = "lbsg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "lbsg"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


###### Load Balancer 

resource "aws_lb" "lb" {
  name                             = "alb"
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.lbsg.id]
  subnets                          = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  enable_cross_zone_load_balancing = true #Default False 

}

####### Load Balancer - Target Group 


resource "aws_lb_target_group" "target-group" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400 # Stickiness duration in seconds (e.g., 86400s = 1 day)
    enabled         = false
  }

  tags = {
    Name = "my-target-group"
  }

}


####### Load Balancer - Listner 



resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

####### Load Balancer - Listner  Rule


resource "aws_lb_listener_rule" "listener-aws_lb_listener_rule" {
  listener_arn = aws_lb_listener.lb-listener.arn
  priority     = 100

  action {
    type = "forward"

  }

  condition {
    path_pattern {
      values = ["/error"]
    }
  }

}


####### EC2 - LB - ATTACHMENT 



resource "aws_lb_target_group_attachment" "lb-attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.instance[count.index].id
  port             = 80
}

output "alb_dns_name" {
  value = aws_lb.lb.dns_name
}

# # ----  Create ACM Certificate


# resource "aws_acm_certificate" "acm" {
#   domain_name = "www.example.com"


# }


# ####### LB-  Listener for HTTPS

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.lb.arn
#   port = 443
#   protocol = "HTTPS"
#   ssl_policy = "ELBSecurityPolicy-2016-08"
#   certificate_arn = aws_acm_certificate.acm.arn

#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.target-group.arn
#   }
# }


