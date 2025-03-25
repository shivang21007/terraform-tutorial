# These are not standard names, i can name whatever i want

variable "ec2_instance_type" {
  default = "t2.micro"
  type    = string
}

variable "ec2_root_storage_size" {
  default = 15
  type    = string
}

variable "ec2_instance_ami_id" {
  default = "ami-0e35ddab05955cf57"
  type    = string
}
