output "external_ip_clickhouse" {
  value       = module.clickhouse.external_ip_address
  description = "network_interface clickhouse"
}

output "external_ip_vector" {
  value       = module.vector.external_ip_address
  description = "network_interface vector"
}

output "external_ip_lighthouse" {
  value       = module.lighthouse.external_ip_address
  description = "network_interface lighthouse"
}