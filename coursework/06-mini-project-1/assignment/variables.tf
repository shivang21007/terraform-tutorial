variable "aws_region" {
  type    = string
  default = "us-east-1"
}


variable "instance_count" {
  type    = number
  default = 2
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ingress_ports" {
  type    = list(number)
  default = [80, 443, 22]
}

variable "user_data_file_path" {
  type    = string
  default = "/Users/shivanggupta/Downloads/shivang-gupta/terraform/coursework/06-mini-project-1/assignment/web-server.sh"
}

variable "server_name" {
  type    = string
  default = "web-server"
}