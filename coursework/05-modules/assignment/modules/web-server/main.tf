resource "aws_instance" "my_servers" {
  count = var.server_count
  ami = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }
}