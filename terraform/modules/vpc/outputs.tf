output "vpc" {
  value = aws_vpc.main
}

output "private_rt" {
  value = aws_route_table.private_rt
}

output "load_balancer_subnet_a" {
  value = aws_subnet.load_balancer_fe_1
}

output "load_balancer_subnet_b" {
  value = aws_subnet.load_balancer_fe_2
}

output "ecs_fe_subnet_a" {
  value = aws_subnet.ecs_fe_1
}

output "ecs_fe_subnet_b" {
  value = aws_subnet.ecs_fe_2
}

output "ecs_be_subnet_a" {
  value = aws_subnet.ecs_be_1
}

output "ecs_be_subnet_b" {
  value = aws_subnet.ecs_be_2
}

output "ecs_rds_subnet_a" {
  value = aws_subnet.rds_1
}

output "ecs_rds_subnet_b" {
  value = aws_subnet.rds_2
}

output "be_elb_subnet_a" {
  value = aws_subnet.load_balancer_be_1
}

output "be_elb_subnet_b" {
  value = aws_subnet.load_balancer_be_2
}

output "fe_elb_subnet_a" {
  value = aws_subnet.load_balancer_fe_1
}

output "fe_elb_subnet_b" {
  value = aws_subnet.load_balancer_fe_2
}

output "fe_load_balancer_sg" {
  value = aws_security_group.alb_fe
}

output "be_load_balancer_sg" {
  value = aws_security_group.alb_be
}

output "ecs_fe_sg" {
  value = aws_security_group.private_ecs_fe
}

output "ecs_be_sg" {
  value = aws_security_group.private_ecs_be
}

output "ecs_alb_sg" {
  value = aws_security_group.alb_fe
}

output "ecs_rds_sg" {
  value = aws_security_group.rds
}

output "ecr_vpc_endpoint_sg" {
  value = aws_security_group.ecr_vpc_endpoint_sg
}