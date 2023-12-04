variable "region" {
  type = string
  default = "ap-southeast-1"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_public_cidr_block" {
  type = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]
}

variable "vpc_private_cidr_block" {
  type = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.103.0/24",
    "10.0.105.0/24",
    "10.0.107.0/24",
    "10.0.109.0/24",
    "10.0.111.0/24",
    "10.0.113.0/24",
    "10.0.115.0/24",
  ]
}

variable "ecs_fe_port" {
  type = number
  default = 3000
}

variable "ecs_be_port" {
  type = number
  default = 3001
}