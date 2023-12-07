variable "ecs_target_group" {
  type = string
  description = "Target group ID for autoscaling of ECS"
}
variable "ecs_subnet_list" {
  type        = list(string)
  description = "List of ECS subnets IDs"
}
variable "ecs_sg" {
  type = string
  description = "Security group ID for ECS"
}
variable "image_url" {
  type = string
  description = "The image url from ECR"
}
variable "db_username" {
  type = string
  description = "Database username"
}
variable "db_password" {
  type = string
  description = "Database password"
}
variable "db_name" {
  type = string
  description = "Database name"
}
variable "db_endpoint" {
  type = string
  description = ""
}
variable "jwt_secret" {
  type = string
  description = "Secret key for JWT"
}
variable "container_port" {
  type = number
  description = "The export port of container"
}
variable "ecs_role_name" {
  type = string
  description = "Role name for ECS execution"
}