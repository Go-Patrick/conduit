resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = "true"
  enable_dns_support = "true"

  tags = {
    "Name" = "turbo-vpc"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "demo1-gw"
  }
}

resource "aws_subnet" "load_balancer_fe_1" {
  vpc_id = aws_vpc.main.id
  availability_zone   = "ap-southeast-1a"
  cidr_block = var.vpc_public_cidr_block[0]

  tags = {
    Name="load-balancer-fe-1"
  }
}

resource "aws_subnet" "load_balancer_fe_2" {
  vpc_id = aws_vpc.main.id
  availability_zone   = "ap-southeast-1b"
  cidr_block = var.vpc_public_cidr_block[1]

  tags = {
    Name="load-balancer-fe-2"
  }
}

resource "aws_subnet" "load_balancer_be_1" {
  vpc_id = aws_vpc.main.id
  availability_zone   = "ap-southeast-1a"
  cidr_block = var.vpc_private_cidr_block[5]

  tags = {
    Name="load-balancer-be-1"
  }
}

resource "aws_subnet" "load_balancer_be_2" {
  vpc_id = aws_vpc.main.id
  availability_zone   = "ap-southeast-1b"
  cidr_block = var.vpc_private_cidr_block[6]

  tags = {
    Name="load-balancer-be-2"
  }
}

resource "aws_subnet" "ecs_be_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1a"
  cidr_block = var.vpc_private_cidr_block[0]

  tags = {
    Name="ecs-be-1"
  }
}

resource "aws_subnet" "ecs_be_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1b"
  cidr_block = var.vpc_private_cidr_block[1]

  tags = {
    Name="ecs-be-2"
  }
}

resource "aws_subnet" "ecs_fe_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1a"
  cidr_block = var.vpc_private_cidr_block[2]

  tags = {
    Name="ecs-fe-1"
  }
}

resource "aws_subnet" "ecs_fe_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1b"
  cidr_block = var.vpc_private_cidr_block[3]

  tags = {
    Name="ecs-fe-2"
  }
}

resource "aws_subnet" "rds_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1a"
  cidr_block = var.vpc_private_cidr_block[4]

  tags = {
    Name="rds-1"
  }
}

resource "aws_subnet" "rds_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1b"
  cidr_block = var.vpc_private_cidr_block[7]

  tags = {
    Name="rds-2"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }
}

resource "aws_route_table_association" "public_1" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.load_balancer_fe_1.id
}

resource "aws_route_table_association" "public_2" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.load_balancer_fe_2.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private_1" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.ecs_be_1.id
}

resource "aws_route_table_association" "private_2" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.ecs_be_2.id
}

resource "aws_route_table_association" "private_3" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.ecs_fe_1.id
}

resource "aws_route_table_association" "private_4" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.ecs_fe_2.id
}

resource "aws_route_table_association" "private_5" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.rds_1.id
}

resource "aws_route_table_association" "private_6" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.load_balancer_be_1.id
}

resource "aws_route_table_association" "private_7" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.load_balancer_be_2.id
}

resource "aws_route_table_association" "private_8" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.rds_2.id
}

resource "aws_security_group" "alb_fe" {
  name = "turbo-alb"
  description = "Allow public internet to connect into load balancer"

  vpc_id = aws_vpc.main.id

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

resource "aws_security_group" "alb_be" {
  name = "turbo-be-alb"
  description = "Allow traffic from ecs"

  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.private_ecs_fe.id]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [aws_security_group.private_ecs_fe.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_ecs_fe" {
  name = "turbo-fe"
  description = "Allow request redirect from load balancer"

  vpc_id = aws_vpc.main.id

  ingress {
    from_port = var.ecs_fe_port
    to_port = var.ecs_fe_port
    protocol = "tcp"
    security_groups = [aws_security_group.alb_fe.id]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_ecs_be" {
  name = "turbo-be"
  description = "Allow request redirect from load balancer"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = var.ecs_be_port
    to_port = var.ecs_be_port
    protocol = "tcp"
    security_groups = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds" {
  name = "turbo-rds"
  description = "Security group for RDS"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow request from ecs backend"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [aws_security_group.private_ecs_be.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecr_vpc_endpoint_sg" {
  name        = "ecr-vpc-endpoint-sg"
  description = "Security group for ECR VPC endpoint"

  vpc_id = aws_vpc.main.id

  # Define ingress and egress rules as needed for your use case
  # For example, allow all traffic from the ECS instances
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.private_ecs_be.id,aws_security_group.private_ecs_fe.id]
  }
  # Add more rules as needed...
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
