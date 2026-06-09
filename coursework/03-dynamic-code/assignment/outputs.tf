output "public_ip" {
  description = "my server public ip"
  value = aws_instance.assignment-03.public_ip
}

output "ami_id" {
  value = data.aws_ami.ubuntu_ami.id
}