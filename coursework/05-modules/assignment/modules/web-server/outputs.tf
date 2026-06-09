output "public_ip" {
  value = aws_instance.my_servers[*].public_ip
}