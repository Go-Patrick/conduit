variable "db_username" {
  type = string
  description = "Database name"
}
variable "db_password" {
  type = string
  description = "Database password"
}
variable "db_name" {
  type = string
  description = "Database name"
}
variable "db_identifier" {
  type = string
  description = "Database identifier"
}

variable "rds_sg" {
  type = string
  description = "Security group ID for RDS"
}
variable "rds_subnet_list" {
  type = list(string)
  description = "List of subnet IDs"
}