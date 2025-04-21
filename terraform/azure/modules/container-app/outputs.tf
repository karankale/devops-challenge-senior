output "latest_revision_fqdn" {
  description = "FQDN of the latest revision"
  value       = azurerm_container_app.this.latest_revision_fqdn
}
