module "vpc" {
  source = "./modules/vpc"
}

#module "elb_be" {
#  source                 = "./modules/elb_be"
#  load_balancer_sg       = module.vpc.be_load_balancer_sg
#  load_balancer_subnet_a = module.vpc.be_elb_subnet_a
#  load_balancer_subnet_b = module.vpc.be_elb_subnet_b
#  vpc                    = module.vpc.vpc
#}

module "elb_fe" {
  source                 = "./modules/elb_fe"
  load_balancer_sg       = module.vpc.fe_load_balancer_sg
  load_balancer_subnet_a = module.vpc.fe_elb_subnet_a
  load_balancer_subnet_b = module.vpc.fe_elb_subnet_b
  vpc                    = module.vpc.vpc
}

module "rds" {
  source        = "./modules/rds"
  db_identifier = var.db_identifier
  db_name       = var.db_name
  db_password   = var.db_password
  db_username   = var.db_username
  rds_sg        = module.vpc.ecs_rds_sg
  vpc           = module.vpc.vpc.id
  rds_subnet_a  = module.vpc.ecs_rds_subnet_a
  rds_subnet_b  = module.vpc.ecs_rds_subnet_b
}

module "ecr" {
  source        = "./modules/ecr"
  be_image_name = var.be_image_name
  fe_image_name = var.fe_image_name
}

module "private_link" {
  source = "./modules/private_link"
  ecr_sg = module.vpc.ecr_vpc_endpoint_sg
  private_rt = module.vpc.private_rt
  vpc = module.vpc.vpc
  ecs_be_subnet_a = module.vpc.ecs_be_subnet_a
  ecs_be_subnet_b = module.vpc.ecs_be_subnet_b
  ecs_fe_subnet_a = module.vpc.ecs_fe_subnet_a
  ecs_fe_subnet_b = module.vpc.ecs_fe_subnet_b
}

module "ecs_be" {
  source           = "./modules/ecs_be"
  db_endpoint      = module.rds.rds_public_url
  db_name          = var.db_name
  db_password      = var.db_password
  db_username      = var.db_username
  ecs_sg           = module.vpc.ecs_be_sg
  ecs_subnet_a     = module.vpc.ecs_be_subnet_a
  ecs_subnet_b     = module.vpc.ecs_be_subnet_b
#  ecs_target_group = module.elb_be.ecs_target_group
  image_url        = module.ecr.ecr_be_url
  jwt_secret       = var.jwt_secret
  rds_url          = module.rds.rds_public_url
  ecr_sg           = module.vpc.ecr_vpc_endpoint_sg
  ecs_target_group = ""
  vpc              = module.vpc.vpc.id
}

module "ecs_fe" {
  source           = "./modules/ecs_fe"
  backend_url      = "backend.turbo.backend.com"
  ecs_sg           = module.vpc.ecs_fe_sg
  ecs_subnet_a     = module.vpc.ecs_fe_subnet_a
  ecs_subnet_b     = module.vpc.ecs_fe_subnet_b
  ecs_target_group = module.elb_fe.ecs_target_group
  image_name       = module.ecr.ecr_fe_url
  vpc              = module.vpc.vpc.id
  ecr_sg           = module.vpc.ecr_vpc_endpoint_sg
}