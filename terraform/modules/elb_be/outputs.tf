output "elb" {
  value = aws_lb.elb
}

output "ecs_target_group" {
  value = aws_lb_target_group.ecs_fe
}

output "lb_url" {
  value = aws_lb.elb.dns_name
}