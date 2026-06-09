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

resource "aws_security_group" "dynamic-sg" {
  name = "web-sg"

  dynamic "ingress" {
    for_each = var.web_ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "my_servers" {
  count = var.create_servers ? var.server_count : 0
  ami = data.aws_ami.ubuntu_ami.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.dynamic-sg.id]

  user_data = file("/Users/shivanggupta/Downloads/shivang-gupta/terraform/00-initial-sandbox/installation_script.sh")

  tags = {
    Name = "Web-Server-${count.index}"
  }
}

