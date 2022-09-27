output "name" {
  description = "Name of the resource group."
  value       = element(concat(azurerm_resource_group.this.*.name, [""]), 0)
}

output "id" {
  description = "Resource ID of the resource group."
  value       = element(concat(azurerm_resource_group.this.*.id, [""]), 0)
}

output "location" {
  description = "Location of the resource group."
  value       = element(concat(azurerm_resource_group.this.*.location, [""]), 0)
}
