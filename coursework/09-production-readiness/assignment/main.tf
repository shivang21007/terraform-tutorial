provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my-bucket" {
  bucket = "shivangguptain-${terraform.workspace}"
}

resource "aws_security_group" "web-sg" {
  name = "web-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example_provisioner" {
  depends_on             = [aws_security_group.web-sg]
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  ami           = "ami-0021ac0c2e69d9c55"
  instance_type = "t3.micro"

  tags = {
    Name = "tetsing-tfsec"
  }
}