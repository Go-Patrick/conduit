output "ecs_cluster" {
  value = aws_ecs_cluster.fe_ecs_cluster
}

output "ecs_service" {
  value = aws_ecs_service.fe_ecs_service
}