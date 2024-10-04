# outputs.tf

output "database_service_ip" {
  description = "The IP of the database service"
  value       = try(kubernetes_service.database.status[0].load_balancer[0].ingress[0].ip, "Pending IP allocation")
}
