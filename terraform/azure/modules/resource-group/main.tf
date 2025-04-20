resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-rg"
  location = var.location
}
