output "elb" {
  value = aws_lb.be_elb
}

output "ecs_target_group" {
  value = aws_lb_target_group.be_tg
}

output "lb_url" {
  value = aws_lb.be_elb.dns_name
}