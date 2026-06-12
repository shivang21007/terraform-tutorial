data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "production-vpc"
  cidr = "10.0.0.0/16"

  # Slice to get the first 3 AZs dynamically
#   azs = slice(data.aws_availability_zones.available.names, 0, 3)
    azs = ["us-east-1a", "us-east-1b"]
    
  # Subnet layouts
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24"]

  # Do not create database subnet group or route table from VPC module?
  # The VPC module automatically creates a route table for database subnets 
  # without internet access by default.
  create_database_subnet_group = false

  # NAT Gateway Strategy (Single NAT saves money; use one per AZ for production HA)
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  # DNS Configuration
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Resource Tagging
  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}