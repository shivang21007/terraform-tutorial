#key pair

resource "aws_key_pair" "my_ssh_key" {
  key_name = "terr-key"
  public_key = file("tf_rsa.pub")
}

# VPC & Security Group

resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "my_security_group" {
  name = "my-sg"
  description = "this is tf generated sg"
  vpc_id = aws_default_vpc.default.id #interpolation

  #inbound rule
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH Open"
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP Open"
    }

  #outbound rule

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "ALL ports and protocol open"
  }
}


#ec2 instance 

resource "aws_instance" "my-server-01" {
  key_name = aws_key_pair.my_ssh_key.key_name
  security_groups = [ aws_security_group.my_security_group.name]
  instance_type = "t2.micro"
  ami = "ami-0e35ddab05955cf57"

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }
  tags = {
    name = "my-serv-01"
  }

}