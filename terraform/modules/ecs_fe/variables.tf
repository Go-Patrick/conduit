variable "ecs_target_group" {}
variable "ecs_subnet_a" {}
variable "ecs_subnet_b" {}
variable "ecs_sg" {}
variable "backend_url" {}
variable "image_name" {}
variable "vpc" {}
variable "ecr_sg" {}

variable "ecs_role_name" {
  type = string
  default = "arn:aws:iam::932782693588:role/IAMECSTaskRole"
}