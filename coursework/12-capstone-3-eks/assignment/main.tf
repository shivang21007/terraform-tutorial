provider "aws" {
  region = "us-east-1"
}

locals {
  cluster_name = "capstone3-eks-cluster"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.cluster_name
  kubernetes_version = "1.34"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  addons = {
    coredns    = {}
    kube-proxy = {
      before_compute = true
    }
    vpc-cni    = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    default = {
      min_size     = 2
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"

    }
  }
}