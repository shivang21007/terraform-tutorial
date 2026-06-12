output "alb_dns_name" {
  value = module.compute.alb_dns_name
}

output "db_instance_endpoint" {
  value = module.database.db_instance_endpoint
}