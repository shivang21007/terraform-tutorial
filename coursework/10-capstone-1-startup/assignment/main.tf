module "netwokring" {
  source = "./modules/networking"
}

module "compute" {
  source = "./modules/compute"

  vpc_id             = module.netwokring.vpc_id
  public_subnet_ids  = module.netwokring.public_subnets
  private_subnet_ids = module.netwokring.private_subnets
}

