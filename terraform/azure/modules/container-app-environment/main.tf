resource "azurerm_container_app_environment" "this" {
  name                = "${var.prefix}-env"
  location            = var.location
  resource_group_name = var.resource_group_name

  logs_destination           = "log-analytics"
  log_analytics_workspace_id = var.log_analytics_workspace_id
}
