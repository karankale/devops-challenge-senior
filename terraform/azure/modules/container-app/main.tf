resource "azurerm_container_app" "this" {
  name                         = "${var.prefix}-app"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.environment_id

  revision_mode = "Single"

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = var.target_port
    transport        = "auto"
    traffic_weight {
      percentage      = 100
      revision_suffix = "v1"
    }
  }
}
