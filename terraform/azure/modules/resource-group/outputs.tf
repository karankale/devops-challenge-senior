output "name" {
  description = "Name of the Resource Group"
  value       = azurerm_resource_group.this.name
}

output "id" {
  description = "ID of the Resource Group"
  value       = azurerm_resource_group.this.id
}
