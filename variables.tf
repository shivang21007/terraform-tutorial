variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-1"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the instances. For security, restrict this to your IP instead of 0.0.0.0/0."
  type        = string
  default     = "0.0.0.0/0" # WARN: Defaulting to open for tutorial purposes, but you should lock this down!
}

variable "ingress_rules" {
  description = "ingress rules"
  type        = list(any)
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH open"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "http open"
    },
  ]
}

variable "egress_rules" {
  description = "egress rules"
  type        = list(any)
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "anywhere"
    },
  ]
}

variable "instances" {
  description = "Map of Instance names of AMI IDs, SSH Users and OS family "

  type = map(object({
    ami           = string
    os_family     = string
    instance_type = string
    volume_size   = number
  }))

  default = {
    # "master-node" = {
    #   ami           = "ami-05d2d839d4f73aafb"
    #   os_family     = "ubuntu"
    #   instance_type = "t3.small"
    #   volume_size = 12
    # }

    "worker-node-1" = {
      ami           = "ami-05cf1e9f73fbad2e2"
      os_family     = "ubuntu"
      instance_type = "t3.micro"
      volume_size   = 10
    }

    "worker-node-2" = {
      ami           = "ami-05cf1e9f73fbad2e2"
      os_family     = "ubuntu"
      instance_type = "t3.micro"
      volume_size   = 10
    }

    # "worker-node-ubuntu" = {
    #   ami           = "ami-05d2d839d4f73aafb"
    #   os_family     = "ubuntu"
    #   instance_type = "t3.micro"
    # }
    # "worker-node-amazon" = {
    #   ami           = "ami-045443a70fafb8bbc"
    #   os_family     = "amazon"
    #   instance_type = "t3.micro"
    # }
    # "worker-node2-redhat" = {
    #     ami = "ami-03793655b06c6e29a"
    #     user = "redhat"
    #     os_family = "redhat"
    #     instance_type = "t3.micro"
    # }
  }


}