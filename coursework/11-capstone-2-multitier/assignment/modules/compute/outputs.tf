output "alb_dns_name" {
  value       = aws_lb.my_lb.dns_name
  description = "DNS name of the ALB"
}

output "app_sg_id" {
  value       = aws_security_group.app_sg.id
  description = "ID of the Application Security Group"
}
