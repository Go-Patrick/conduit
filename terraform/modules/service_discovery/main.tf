resource "aws_service_discovery_private_dns_namespace" "turbo_be" {
  name = "turbo.com"
  vpc  = var.vpc
}