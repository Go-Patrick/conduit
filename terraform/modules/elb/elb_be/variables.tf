variable "load_balancer_sg" {
  type = string
  description = "Security group ID for load balancer"
}
variable "load_balancer_subnet_list" {
  type = list(string)
  description = "List of subnet IDs"
}
variable "vpc" {
  type = string
  description = "VPC ID"
}
variable "ecs_port" {
  type = number
  description = "Port number for ECS container"
}