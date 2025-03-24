# These are not standard names, i can name whatever i want

output "ec2_instance_public_ip" { 
  value = aws_instance.my-server-01.public_ip #interpolation
}

# output "ec2_instance_user" {
#   value = aws_instance.my-server-01.us
# }

output "ec2_public_dns" {
  value = aws_instance.my-server-01.public_dns #interpolation
}
output "ec2_private_dns" {
  value = aws_instance.my-server-01.private_dns #interpolation
}