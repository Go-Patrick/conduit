output "vpc" {
  value = aws_vpc.main_vpc
}

output "private_rt" {
  value = aws_route_table.private_rt
}

output "load_balancer_subnet_a" {
  value = aws_subnet.fe_alb_subnet_1
}

output "load_balancer_subnet_b" {
  value = aws_subnet.fe_alb_subnet_2
}

output "ecs_fe_subnet_a" {
  value = aws_subnet.ecs_fe_subnet_1
}

output "ecs_fe_subnet_b" {
  value = aws_subnet.ecs_fe_subnet_2
}

output "ecs_be_subnet_a" {
  value = aws_subnet.ecs_be_subnet_1
}

output "ecs_be_subnet_b" {
  value = aws_subnet.ecs_be_subnet_2
}

output "ecs_rds_subnet_a" {
  value = aws_subnet.rds_subnet_1
}

output "ecs_rds_subnet_b" {
  value = aws_subnet.rds_subnet_2
}

output "be_elb_subnet_a" {
  value = aws_subnet.be_elb_subnet_1
}

output "be_elb_subnet_b" {
  value = aws_subnet.be_elb_subnet_2
}

output "fe_elb_subnet_a" {
  value = aws_subnet.fe_alb_subnet_1
}

output "fe_elb_subnet_b" {
  value = aws_subnet.fe_alb_subnet_2
}

output "fe_load_balancer_sg" {
  value = aws_security_group.alb_fe_sg
}

output "be_load_balancer_sg" {
  value = aws_security_group.alb_be_sg
}

output "ecs_fe_sg" {
  value = aws_security_group.ecs_fe_sg
}

output "ecs_be_sg" {
  value = aws_security_group.ecs_be_sg
}

output "ecs_alb_sg" {
  value = aws_security_group.alb_fe_sg
}

output "ecs_rds_sg" {
  value = aws_security_group.rds_sg
}