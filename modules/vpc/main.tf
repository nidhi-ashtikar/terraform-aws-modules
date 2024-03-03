#VPC block

resource "aws_vpc" "main-vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Vpc"
  }
}

#============================================SUBNET - Public Subnet =========================================


#*============*---------Public Subnet -------------*===========


resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.public_subnets_cidr
  availability_zone = var.avaliablity_zone

  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"

  }
}




#------------Internet gateway for the public subnet -----------------------

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "internet_gateway"

  }
}

#-----------------Elastic IP for NAT----------------------

resource "aws_eip" "nat_elastic_ip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]
}

# ------------------- NAT Gateway - public  -----------------------


resource "aws_nat_gateway" "vpc_nat" {
  allocation_id = aws_eip.nat_elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.internet_gateway]

  tags = {
    Name = "vpc_nat"
  }
}

# ------------------- Routing table for public subnet  -----------------------



resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "route_table_public"

  }
}


# ------------------- Routing table for public subnet  -----------------------



resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

#  ------------------- Route table_association for public subnet - for private subnet  -----------------------


resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table_public.id
}







#============================================SUBNET - Private Subnet =========================================

#*============*---------Private Subnet -------------*===========

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.private_subnets_cidr
  availability_zone = var.avaliablity_zone


  map_public_ip_on_launch = false


  tags = {
    Name = "private_subnet"
  }
}


# ------------------- Routing table for private subnet  -----------------------



resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "route_table_private"

  }
}


# ------------------- Route for private subnet  -----------------------

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.route_table_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc_nat.id
}


#  ------------------- Route for private subnet - for private subnet  -----------------------

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.route_table_private.id
}


# *********** ------------------- Security Group for VPC  -----------------------**************8


resource "aws_security_group" "my_security_group" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.main-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }   

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-security-group"
  }
}



