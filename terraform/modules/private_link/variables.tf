variable "vpc" {}
variable "region" {
  type = string
  default = "ap-southeast-1"
}
variable "ecr_sg" {}
variable "private_rt" {}
variable "ecs_fe_subnet_a" {}
variable "ecs_fe_subnet_b" {}
variable "ecs_be_subnet_a" {}
variable "ecs_be_subnet_b" {}