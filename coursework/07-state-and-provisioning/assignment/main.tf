provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "provisioner_key" {
  key_name   = "provisioner-key"
  public_key = file("${path.module}/key/terraform-key.pem.pub")
}

resource "aws_security_group" "web-sg" {
  name = "web-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example_provisioner" {
  depends_on             = [aws_security_group.web-sg]
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  ami           = "ami-0021ac0c2e69d9c55"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.provisioner_key.key_name

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/key/terraform-key.pem")
    host        = self.public_ip
  }

  tags = {
    Name = "Terraform-Provisioner-Test-Instance"
  }

  #this will copy the file from the local machine to the EC2 instance
  provisioner "file" {
    source      = "./hello.sh"
    destination = "/tmp/hello.sh"
  }
  #this will run on the EC2 instance (it uses ssh connection defined above to copy files)
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/hello.sh",
      "/tmp/hello.sh > /tmp/hello_output.txt"
    ]
  }

  # This will run on your laptop after the EC2 instance is created.
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }
}

resource "aws_s3_bucket" "imported_bucket" {
  bucket = "shivag-josh-batch-10"
  
}
#$ tf import aws_s3_bucket.imported_bucket  shivag-josh-batch-10