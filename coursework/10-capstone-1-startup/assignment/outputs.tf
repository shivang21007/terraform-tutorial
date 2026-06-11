output "alb_dns_name" {
  value       = module.compute.alb_dns_name
  description = "DNS name of the ALB"
}

output "public_subnet" {
  value       = module.netwokring.public_subnets
  description = "List of IDs of public subnets"
}

output "private_subnet" {
  value       = module.netwokring.private_subnets
  description = "List of IDs of private subnets"
}

output "vpc_id" {
  value = module.netwokring.vpc_id
}