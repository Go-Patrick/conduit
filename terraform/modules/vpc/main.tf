resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = "true"
  enable_dns_support = "true"

  tags = {
    "Name" = "turbo-vpc-${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    "Name" = "demo1-gw-${terraform.workspace}"
  }
}

resource "aws_subnet" "fe_alb_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id
  availability_zone   = "ap-southeast-1a"
  cidr_block = var.vpc_public_cidr_block[0]

  tags = {
    Name="load-balancer-fe-1"
  }
}

resource "aws_subnet" "fe_alb_subnet_2" {
  vpc_id = aws_vpc.main_vpc.id
  availability_zone   = "ap-southeast-1b"
  cidr_block = var.vpc_public_cidr_block[1]

  tags = {
    Name="load-balancer-fe-2-${terraform.workspace}"
  }
}

resource "aws_subnet" "nat_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  availability_zone   = "ap-southeast-1a"
  cidr_block = var.vpc_public_cidr_block[2]

  tags = {
    Name="nat-${terraform.workspace}"
  }
}

resource "aws_subnet" "be_elb_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id
  availability_zone   = "ap-southeast-1a"
  cidr_block = var.vpc_private_cidr_block[5]

  tags = {
    Name="load-balancer-be-1-${terraform.workspace}"
  }
}

resource "aws_subnet" "be_elb_subnet_2" {
  vpc_id = aws_vpc.main_vpc.id
  availability_zone   = "ap-southeast-1b"
  cidr_block = var.vpc_private_cidr_block[6]

  tags = {
    Name="load-balancer-be-2-${terraform.workspace}"
  }
}

resource "aws_subnet" "ecs_be_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = "ap-southeast-1a"
  cidr_block = var.vpc_private_cidr_block[0]

  tags = {
    Name="ecs-be-1-${terraform.workspace}"
  }
}

resource "aws_subnet" "ecs_be_subnet_2" {
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = "ap-southeast-1b"
  cidr_block = var.vpc_private_cidr_block[1]

  tags = {
    Name="ecs-be-2-${terraform.workspace}"
  }
}

resource "aws_subnet" "ecs_fe_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = "ap-southeast-1a"
  cidr_block = var.vpc_private_cidr_block[2]

  tags = {
    Name="ecs-fe-1-${terraform.workspace}"
  }
}

resource "aws_subnet" "ecs_fe_subnet_2" {
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = "ap-southeast-1b"
  cidr_block = var.vpc_private_cidr_block[3]

  tags = {
    Name="ecs-fe-2-${terraform.workspace}"
  }
}

resource "aws_subnet" "rds_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = "ap-southeast-1a"
  cidr_block = var.vpc_private_cidr_block[4]

  tags = {
    Name="rds-1-${terraform.workspace}"
  }
}

resource "aws_subnet" "rds_subnet_2" {
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = "ap-southeast-1b"
  cidr_block = var.vpc_private_cidr_block[7]

  tags = {
    Name="rds-2-${terraform.workspace}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }
}

resource "aws_route_table_association" "public_associate_1" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.fe_alb_subnet_1.id
}

resource "aws_route_table_association" "public_associate_2" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.fe_alb_subnet_2.id
}

resource "aws_route_table_association" "public_associate_3" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.nat_subnet.id
}

resource "aws_eip" "app_nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main_nat_gw" {
  allocation_id = aws_eip.app_nat_eip.id
  subnet_id     = aws_subnet.nat_subnet.id
}

resource "aws_route_table" "private_nat_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    nat_gateway_id = aws_nat_gateway.main_nat_gw.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "private_1" {
  route_table_id = aws_route_table.private_nat_rt.id
  subnet_id = aws_subnet.ecs_be_subnet_1.id
}

resource "aws_route_table_association" "private_2" {
  route_table_id = aws_route_table.private_nat_rt.id
  subnet_id = aws_subnet.ecs_be_subnet_2.id
}

resource "aws_route_table_association" "private_3" {
  route_table_id = aws_route_table.private_nat_rt.id
  subnet_id = aws_subnet.ecs_fe_subnet_1.id
}

resource "aws_route_table_association" "private_4" {
  route_table_id = aws_route_table.private_nat_rt.id
  subnet_id = aws_subnet.ecs_fe_subnet_2.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table_association" "private_5" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.rds_subnet_1.id
}

resource "aws_route_table_association" "private_6" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.be_elb_subnet_1.id
}

resource "aws_route_table_association" "private_7" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.be_elb_subnet_2.id
}

resource "aws_route_table_association" "private_8" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.rds_subnet_2.id
}

resource "aws_security_group" "alb_fe_sg" {
  name = "turbo-alb-${terraform.workspace}"
  description = "Allow public internet to connect into load balancer"

  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_be_sg" {
  name = "turbo-be-alb"
  description = "Allow traffic from ecs"

  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_fe_sg" {
  name = "turbo-fe-${terraform.workspace}"
  description = "Allow request redirect from load balancer"

  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port = var.ecs_fe_port
    to_port = var.ecs_fe_port
    protocol = "tcp"
    security_groups = [aws_security_group.alb_fe_sg.id]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_be_sg" {
  name = "turbo-be-${terraform.workspace}"
  description = "Allow request redirect from load balancer"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port = var.ecs_be_port
    to_port = var.ecs_be_port
    protocol = "tcp"
    security_groups = [aws_security_group.alb_be_sg.id]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name = "turbo-rds-${terraform.workspace}"
  description = "Security group for RDS"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    description = "Allow request from ecs backend"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [aws_security_group.ecs_be_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}