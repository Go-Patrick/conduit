output "ecs_cluster" {
  value = aws_ecs_cluster.turbo_fe
}

output "ecs_service" {
  value = aws_ecs_service.turbo_fe
}