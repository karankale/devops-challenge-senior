module "resource_group" {
  source   = "./modules/resource-group"
  prefix   = var.prefix
  location = var.location
}

module "log_analytics" {
  source              = "./modules/log-analytics"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
}

module "container_app_environment" {
  source                     = "./modules/container-app-environment"
  prefix                     = var.prefix
  location                   = var.location
  resource_group_name        = module.resource_group.name
  log_analytics_workspace_id = module.log_analytics.id
}

module "container_app" {
  source              = "./modules/container-app"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
  environment_id      = module.container_app_environment.id
  container_image     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}
