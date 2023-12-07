module "vpc" {
  source = "./modules/vpc"
}

module "elb_be" {
  source                 = "./modules/elb/elb_be"
  load_balancer_sg       = module.vpc.be_load_balancer_sg.id
  load_balancer_subnet_list = [module.vpc.be_elb_subnet_a.id,module.vpc.be_elb_subnet_b.id]
  vpc                    = module.vpc.vpc.id
  ecs_port               = 3001
}

module "elb_fe" {
  source                 = "./modules/elb/elb_fe"
  load_balancer_sg       = module.vpc.fe_load_balancer_sg.id
  load_balancer_subnet_list = [module.vpc.fe_elb_subnet_a.id,module.vpc.fe_elb_subnet_b.id]
  vpc                    = module.vpc.vpc.id
  ecs_port = 3000
}

module "rds" {
  source        = "./modules/rds"
  db_identifier = var.db_identifier
  db_name       = var.db_name
  db_password   = var.db_password
  db_username   = var.db_username
  rds_sg        = module.vpc.ecs_rds_sg.id
  rds_subnet_list = [module.vpc.ecs_rds_subnet_a.id,module.vpc.ecs_rds_subnet_b.id]
}

module "ecr" {
  source        = "./modules/ecr"
  be_image_name = var.be_image_name
  fe_image_name = var.fe_image_name
}

module "ecs_be" {
  source           = "./modules/ecs/ecs_be"
  db_endpoint      = module.rds.rds_public_url
  db_name          = var.db_name
  db_password      = var.db_password
  db_username      = var.db_username
  ecs_sg           = module.vpc.ecs_be_sg.id
  ecs_subnet_list = [module.vpc.ecs_be_subnet_a.id, module.vpc.ecs_be_subnet_b.id]
  image_url        = module.ecr.ecr_be_url
  jwt_secret       = var.jwt_secret
  ecs_target_group = module.elb_be.ecs_target_group.id
  ecs_role_name = var.ecs_role_name
  container_port   = 3001
}

module "ecs_fe" {
  source           = "./modules/ecs/ecs_fe"
  ecs_sg           = module.vpc.ecs_fe_sg.id
  ecs_subnet_list = [module.vpc.ecs_fe_subnet_a.id, module.vpc.ecs_fe_subnet_b.id]
  ecs_target_group = module.elb_fe.ecs_target_group.id
  image_name       = module.ecr.ecr_fe_url
  ecs_role_name = var.ecs_role_name
  container_port   = 3000
}