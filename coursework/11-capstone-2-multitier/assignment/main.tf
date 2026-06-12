provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source = "./modules/networking"
}

module "compute" {
  source             = "./modules/compute"
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnets
  private_subnet_ids = module.networking.private_subnets
}

module "database" {
  source              = "./modules/database"
  vpc_id              = module.networking.vpc_id
  database_subnet_ids = module.networking.database_subnets
  app_sg_id           = module.compute.app_sg_id
  db_username         = "dbadmin"
  db_password         = "supersecretpassword"
}


