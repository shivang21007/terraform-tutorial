output "frontend_server_ips" {
  description = "The public IPs of the frontend servers"
  value       = module.frontend_server.public_ip
}
