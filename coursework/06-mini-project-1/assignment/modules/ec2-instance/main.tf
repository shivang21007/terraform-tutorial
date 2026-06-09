resource "aws_security_group" "my-security-group" {
  name = "web-sg"

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_servers" {
  count                  = var.server_count
  ami                    = var.ami_id[count.index]
  instance_type          = var.instance_type
  user_data              = file(var.user_Data_file_path)
  vpc_security_group_ids = [aws_security_group.my-security-group.id]

  tags = {
    Name = var.server_count < 2 ? var.server_name : "${var.server_name}-${count.index + 1}"
  }
}
