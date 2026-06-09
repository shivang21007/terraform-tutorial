terraform {
  backend "s3" {
    bucket = "coursework-terraform-state-bucket"
    key = "coursework/terraform.tfstate"
    region = "ap-south-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "module2_server" {
  ami = "ami-0021ac0c2e69d9c55"
  instance_type = "t3.micro"
  tags = {
    Name = "module2_server"
  }
  
}