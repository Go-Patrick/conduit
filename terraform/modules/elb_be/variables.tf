variable "load_balancer_sg" {}
variable "load_balancer_subnet_a" {}
variable "load_balancer_subnet_b" {}
variable "vpc" {}
variable "ecs_port" {
  type = number
  default = 3001
}