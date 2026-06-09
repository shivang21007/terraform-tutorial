variable "aws_region" {
    type = string
  default = "us-east-1"
}

variable "create_servers" {
  type = bool
  default = true
}

variable "server_count" {
  type = number
  default = 2
}

variable "web_ports" {
  type = list(number)
  default = [ 80,443, 22]
}

output "public_ip" {
  value = aws_instance.my_servers[*].public_ip
}