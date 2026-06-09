variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = list(string)
}
variable "server_count" {
  type = number
}

variable "server_name" {
  type = string
}

variable "ingress_ports" {
  type = list(number)
}

variable "user_Data_file_path" {
  type = string
}
