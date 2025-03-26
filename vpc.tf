module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc-01"
  cidr = "192.168.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["192.168.128.0/20", "192.168.144.0/20"]
  public_subnets  = ["192.168.0.0/20", "192.168.16.0/20"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}