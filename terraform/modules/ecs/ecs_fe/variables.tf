variable "ecs_target_group" {
  type = string
  description = "Target group id for ECS"
}
variable "ecs_subnet_list" {
  type        = list(string)
  description = "List of ECS subnets IDs"
}
variable "ecs_sg" {
  type = string
  description = "Security group ID for ECS"
}
variable "image_name" {
  type = string
  description = "Name of the image to ECR"
}
variable "container_port" {
  type = number
  description = "Port number of container"
}

variable "ecs_role_name" {
  type = string
  description = "Role name for ECS execution"
}