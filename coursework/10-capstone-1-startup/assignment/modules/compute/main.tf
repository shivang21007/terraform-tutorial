resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP and HTTPS traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow HTTP, HTTPS and SSH traffic to EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

resource "aws_lb" "my_lb" {
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my_lb.arn
  port                = 80
  protocol            = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

resource "aws_key_pair" "tf-key" {
  key_name   = "terraform-key"
  public_key = file("/Users/shivanggupta/Downloads/shivang-gupta/terraform/coursework/10-capstone-1-startup/assignment/key/terraform-key.pem.pub")
}

resource "aws_launch_template" "ec2_template" {
  name_prefix = "ec2-template-"
  key_name    = aws_key_pair.tf-key.key_name

  image_id      = "ami-0021ac0c2e69d9c55"
  instance_type = "t3.micro"

  network_interfaces {
    security_groups = [aws_security_group.ec2_sg.id]
  }

  user_data = filebase64("/Users/shivanggupta/Downloads/shivang-gupta/terraform/coursework/10-capstone-1-startup/assignment/modules/compute/install.sh")

  tags = {
    Name = "ec2-template"
  }
}

resource "aws_autoscaling_group" "my_asg" {
  name                      = "my-asg"
  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.my_target_group.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300
}