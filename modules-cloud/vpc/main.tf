
# resource "aws_vpc" "vpc" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true


#   tags = {
#     Name = "VPC"
#   }
# }


# resource "aws_subnet" "public-subnet-1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = "10.0.0.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true

# }


# resource "aws_subnet" "public-subnet-2" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true

# }




# resource "aws_internet_gateway" "ig" {
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "ig"
#   }
# }

# resource "aws_route_table" "rt" {
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.ig.id

#   }
# }

# resource "aws_route_table_association" "rt-ass1" {
#   route_table_id = aws_route_table.rt.id
#   subnet_id      = aws_subnet.public-subnet-1.id

# }

# resource "aws_route_table_association" "rt-ass2" {
#   route_table_id = aws_route_table.rt.id
#   subnet_id      = aws_subnet.public-subnet-2.id
# }
