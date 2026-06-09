provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "my_first_server" {
  ami = "ami-0021ac0c2e69d9c55"
  instance_type = "t3.micro"
  tags = {
    Name = "Terraform-Student-Server"
  }
}