variable "ecs_target_group" {}
variable "ecs_subnet_a" {}
variable "ecs_subnet_b" {}
variable "ecs_sg" {}
variable "rds_url" {}
variable "image_url" {}
variable "db_username" {}
variable "db_password" {}
variable "db_name" {}
variable "db_endpoint" {}
variable "jwt_secret" {}
variable "ecr_sg" {}
variable "vpc" {}
#variable "service_namespace" {}

variable "ecs_role_name" {
  type = string
  default = "arn:aws:iam::932782693588:role/IAMECSTaskRole"
}