output "ecr_be_url" {
  value = aws_ecr_repository.conduit_be.repository_url
  description = "The URL of the ECR backend"
}

output "ecr_fe_url" {
  value = aws_ecr_repository.conduit_fe.repository_url
  description = "The URL of the ECR frontend"
}