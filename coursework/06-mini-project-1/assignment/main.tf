provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu_linux" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS Account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

module "web-servers" {
  source = "./modules/ec2-instance"

  server_count  = var.instance_count
  server_name   = var.server_name
  ami_id        = [data.aws_ami.ubuntu_linux.id,data.aws_ami.amazon_linux.id]
  instance_type = var.instance_type
  ingress_ports = var.ingress_ports

  user_Data_file_path = var.user_data_file_path
}