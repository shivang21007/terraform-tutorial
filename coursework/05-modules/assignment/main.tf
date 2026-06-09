provider "aws" {
  region = "us-east-1"
}

module "frontend_server" {
  source = "./modules/web-server"
  server_count = 2
  ami_id = "ami-0021ac0c2e69d9c55"
  instance_name = "frontend-prod"
  instance_type = "t3.micro"
}

