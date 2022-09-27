output "name" {
  description = "Name of the resource group."
  value       = module.resource_group_default.name
}

output "id" {
  description = "Resource ID of the resource group."
  value       = module.resource_group_default.id
}

output "location" {
  description = "Location of the resource group."
  value       = module.resource_group_default.location
}
