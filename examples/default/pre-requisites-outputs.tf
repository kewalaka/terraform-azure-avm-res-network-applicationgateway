output "backend_subnet_id" {
  description = "ID of the Backend Subnet"
  value       = azapi_resource.subnet_backend.id
}

output "backend_subnet_name" {
  description = "Name of the Backend Subnet"
  value       = azapi_resource.subnet_backend.name
}

# Output for Subnets
output "frontend_subnet_id" {
  description = "ID of the Frontend Subnet"
  value       = azapi_resource.subnet_frontend.id
}

# Output for Subnets
output "frontend_subnet_name" {
  description = "Name of the Frontend Subnet"
  value       = azapi_resource.subnet_frontend.name
}

output "private_ip_test_subnet_id" {
  description = "ID of the Private IP Test Subnet"
  value       = azapi_resource.subnet_private_ip_test.id
}

output "private_ip_test_subnet_name" {
  description = "Name of the Private IP Test Subnet"
  value       = azapi_resource.subnet_private_ip_test.name
}

# Output for Resource Group
output "resource_group_id" {
  description = "ID of the Azure Resource Group"
  value       = azapi_resource.rg_group.id
}

# Output for Resource Group
output "resource_group_name" {
  description = "Name of the Azure Resource Group"
  value       = azapi_resource.rg_group.name
}

# Output for Virtual Network
output "virtual_network_id" {
  description = "ID of the Azure Virtual Network"
  value       = azapi_resource.vnet.id
}

# Output for Virtual Network
output "virtual_network_name" {
  description = "Name of the Azure Virtual Network"
  value       = azapi_resource.vnet.name
}

output "workload_subnet_id" {
  description = "ID of the Workload Subnet"
  value       = azapi_resource.subnet_workload.id
}

output "workload_subnet_name" {
  description = "Name of the Workload Subnet"
  value       = azapi_resource.subnet_workload.name
}
