output "rds_public_url" {
  value = aws_db_instance.postgres.endpoint
}