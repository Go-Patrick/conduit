output "ecr_be_url" {
  value = "${aws_ecr_repository.api_ecr.repository_url}:latest"
  description = "The URL of the ECR backend"
}

output "ecr_fe_url" {
  value = "${aws_ecr_repository.fe_ecr.repository_url}:latest"
  description = "The URL of the ECR frontend"
}