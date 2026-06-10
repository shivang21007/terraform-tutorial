provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "terraform-key" {
  key_name   = "terraform-key"
  public_key = file("${path.module}/key/terraform-key.pem.pub")
}

resource "aws_vpc" "my-aws_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "custom-vpc"
  }
}

resource "aws_subnet" "my-pub-subnet" {
  vpc_id = aws_vpc.my-aws_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "pubic-subnet"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-aws_vpc.id
  tags = {
    Name = "custom-igw"
  }
}

resource "aws_route_table" "my-aws-public-route-table" {
  vpc_id = aws_vpc.my-aws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
}

resource "aws_route_table_association" "my-public-table-association" {
  subnet_id = aws_subnet.my-pub-subnet.id
  route_table_id = aws_route_table.my-aws-public-route-table.id
}


resource "aws_subnet" "my-priv-subnet" {
  vpc_id = aws_vpc.my-aws_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_eip" "my-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my-nat" {
  allocation_id = aws_eip.my-eip.id
  subnet_id = aws_subnet.my-pub-subnet.id
}

resource "aws_route_table" "my-aws-private-route-table" {
  vpc_id = aws_vpc.my-aws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-nat.id
  }
}

resource "aws_route_table_association" "my-private-table-association" {
  subnet_id = aws_subnet.my-priv-subnet.id
  route_table_id = aws_route_table.my-aws-private-route-table.id
}

resource "aws_security_group" "my-pub-sg" {
  name = "my-pub-sg"
  vpc_id = aws_vpc.my-aws_vpc.id

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

resource "aws_security_group" "my-priv-sg" {
  name = "my-priv-sg"
  vpc_id = aws_vpc.my-aws_vpc.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.my-pub-sg.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.my-pub-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "my-public-host" {
  depends_on = [aws_key_pair.terraform-key]
  ami = "ami-0021ac0c2e69d9c55"
  key_name = aws_key_pair.terraform-key.key_name
  instance_type = "t3.micro"
  
  subnet_id = aws_subnet.my-pub-subnet.id
  vpc_security_group_ids = [aws_security_group.my-pub-sg.id]
  user_data = file("${path.module}/install.sh")
  tags = {
    Name = "public-host"
  }
}

resource "aws_instance" "my-private-host" {
  depends_on = [aws_key_pair.terraform-key]
  ami = "ami-0021ac0c2e69d9c55"
  key_name = aws_key_pair.terraform-key.key_name
  instance_type = "t3.micro"

  subnet_id = aws_subnet.my-priv-subnet.id
  vpc_security_group_ids = [aws_security_group.my-priv-sg.id]
  user_data = file("${path.module}/install.sh")
  tags = {
    Name = "private-host"
  }
}

output "public_ip" {
  value = aws_instance.my-public-host.public_ip
}

output "private_ip" {
  value = aws_instance.my-private-host.private_ip
}