resource "aws_service_discovery_private_dns_namespace" "turbo_be" {
  name = "turbo.backend.com"
  vpc  = var.vpc
}