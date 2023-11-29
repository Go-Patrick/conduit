//Endpoint for ECR
resource "aws_vpc_endpoint" "ecr-fe-dkr" {
  service_name = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_id       = var.vpc.id
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids = [var.ecr_sg.id]
  subnet_ids = [var.ecs_be_subnet_a.id,var.ecs_fe_subnet_b.id]

  tags = {
    Name="ecs-fe-dkr"
  }
}

resource "aws_vpc_endpoint" "ecr-fe-api" {
  service_name = "com.amazonaws.${var.region}.ecr.api"
  vpc_id       = var.vpc.id
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids = [var.ecr_sg.id]
  subnet_ids = [var.ecs_be_subnet_a.id,var.ecs_fe_subnet_b.id]

  tags = {
    Name="ecs-fe-api"
  }
}

resource "aws_vpc_endpoint" "ecr-fe-logs" {
  service_name = "com.amazonaws.${var.region}.logs"
  vpc_id       = var.vpc.id
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids = [var.ecr_sg.id]
  subnet_ids = [var.ecs_be_subnet_a.id,var.ecs_fe_subnet_b.id]

  tags = {
    Name="ecs-fe-logs"
  }
}

resource "aws_vpc_endpoint" "ecr-fe-s3" {
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_id       = var.vpc.id
  vpc_endpoint_type = "Gateway"
  route_table_ids = [var.private_rt.id]

  tags = {
    Name="ecs-fe-s3"
  }
}