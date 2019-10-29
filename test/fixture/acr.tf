resource "azurerm_container_registry" "acr" {
  name                = format("acr%s", random_string.test.result)
  location            = var.location
  resource_group_name = basename(module.rg.id)
  sku                 = "Basic"
  admin_enabled       = true
}
