output "alb_dns_name" {
  value       = aws_lb.my_lb.dns_name
  description = "DNS name of the ALB"
}
