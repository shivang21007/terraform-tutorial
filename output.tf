# These are not standard names, i can name whatever i want

# [*] works with count (meta attribute)
# output "ec2_instance_public_ip" {
#   value = aws_instance.my_instance[*].public_ip #interpolation
# }

# output "ec2_public_dns" {
#   value = aws_instance.my_instance[*].public_dns #interpolation
# }
# output "ec2_private_dns" {
#   value = aws_instance.my_instance[*].private_dns #interpolation
# }


output "ec2_instance_public_ip" {
  value = [
    for idx in aws_instance.my_instance : idx.public_ip
  ]
}