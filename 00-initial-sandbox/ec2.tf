# Region
provider "aws" {
  region = var.aws_region
}

# Key Value pair

resource "aws_key_pair" "my_key_pair" {
  key_name   = "key/terraform-key"
  public_key = file("key/terraform-key.pem.pub")
}

# VPC Data Source
# BEST PRACTICE: It's often safer to use a 'data' block to fetch the default VPC 
# instead of an 'aws_default_vpc' resource which adopts the VPC into Terraform state.
# But for learning/tutorials, aws_default_vpc is perfectly fine.

# resource "aws_default_vpc" "default" {
# } #(resource block for default vpc)

data "aws_vpc" "default" {
  default = true
} #(data block for default vpc)

# Security Group 

resource "aws_security_group" "my_security_group" {

  name = "terra-security-group"
  # vpc_id    = aws_default_vpc.default.id # interpolation(if used resource block)
  vpc_id      = data.aws_vpc.default.id # interpolation (if used data block)
  description = "this is Inbound and outbound rules for your instance Security group"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = lookup(ingress.value, "description", null)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = lookup(egress.value, "description", null)
    }
  }


}

# # Inbound & Outbount port rules
# resource "aws_vpc_security_group_ingress_rule" "allow_http" {
#   security_group_id = aws_security_group.my_security_group.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
#   security_group_id = aws_security_group.my_security_group.id

#   # BEST PRACTICE: Avoid 0.0.0.0/0 on port 22 in production.
#   # This makes your instances vulnerable to brute-force attacks across the internet.
#   cidr_ipv4 = "0.0.0.0/0"

#   from_port   = 22
#   ip_protocol = "tcp"
#   to_port     = 22
# }


# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
#   security_group_id = aws_security_group.my_security_group.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }


# EC2 instance
resource "aws_instance" "my_instance" {

  # count = 3
  # this make sure that the instance is created after the security group is created
  depends_on = [aws_security_group.my_security_group]

  for_each = var.instances

  ami = each.value.ami

  instance_type = each.value.instance_type

  key_name = aws_key_pair.my_key_pair.key_name # Key pair

  vpc_security_group_ids = [aws_security_group.my_security_group.id] # VPC & Security Group

  user_data = file("./installation_script.sh")

  # # Spot Instance Request
  # instance_market_options {
  #   market_type = "spot"
  #   spot_options {
  #     spot_instance_type = "one-time"
  #   }
  # }

  # root storage (EBS)
  root_block_device {
    volume_size = each.value.volume_size
    volume_type = "gp3"
  }

  tags = {
    # Name = "terra-automate-server"
    Name      = each.key
    os_family = each.value.os_family
  }
}