#key pair

resource "aws_key_pair" "my_ssh_key" {
  key_name   = "terr-key"
  public_key = file("tf_rsa.pub")
}

# VPC 
resource "aws_default_vpc" "default" {

}

# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "my-sg"
  description = "this is tf generated sg"
  vpc_id      = aws_default_vpc.default.id #interpolation

  #inbound rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Open"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Open"
  }

  #outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ALL ports and protocol open"
  }
}


#ec2 instance 
resource "aws_instance" "my_instance" {
  # count = 2    #this is for multiple instances

  # this is for multiple instances but with different instance configuration
  for_each = tomap({
    my-server-01 = "t2.micro"
    my-server-02 = "t2.micro"
  })

  key_name        = aws_key_pair.my_ssh_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  #instance_type   = var.ec2_instance_type   #(this is for single instance)
  instance_type = each.value
  ami           = var.ec2_instance_ami_id

  user_data = file("./installation_script.sh")

  root_block_device {
    volume_size = var.ec2_root_storage_size
    volume_type = "gp3"
  }
  tags = {
    name = each.key
    # this create tag for each instance
  }

}