output "container_app_url" {
  description = "Public URL of the Container App"
  value       = "https://${module.container_app.latest_revision_fqdn}"
}
