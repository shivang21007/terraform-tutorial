provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu_ami" {
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

locals {
  common_tags = {
    Owner       = "Engineering Team"
    Environment = "Production"
    }
}

resource "aws_instance" "assignment-03" {
  ami = data.aws_ami.ubuntu_ami.id
  instance_type = var.instance_type
  tags = {
    Name = local.common_tags.Environment
  }
}

