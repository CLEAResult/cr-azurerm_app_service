module "docker_appservice" {
  source          = "../.."
  rg_name         = basename(module.rg.id)
  rgid            = var.rgid
  environment     = var.environment
  location        = var.location
  name_prefix     = format("%s0", random_string.test.result)
  num             = 1
  slot_num        = var.slot_num
  plan            = azurerm_app_service_plan.linux.id
  subscription_id = var.subscription_id
  http2_enabled   = var.http2_enabled
  fx              = "docker"
  fx_version      = "appsvcsample/python-helloworld:latest"
  ip_restrictions = var.ip_restrictions
}

module "docker_appservice-empty-container" {
  source          = "../.."
  rg_name         = basename(module.rg.id)
  rgid            = var.rgid
  environment     = var.environment
  location        = var.location
  name_prefix     = format("%s0empty", random_string.test.result)
  num             = 1
  slot_num        = var.slot_num
  plan            = azurerm_app_service_plan.linux.id
  subscription_id = var.subscription_id
  http2_enabled   = var.http2_enabled
  fx              = "docker"
  fx_version      = ""
  ip_restrictions = var.ip_restrictions
}

module "compose_appservice" {
  source          = "../.."
  rg_name         = basename(module.rg.id)
  rgid            = var.rgid
  environment     = var.environment
  location        = var.location
  name_prefix     = format("%s1", random_string.test.result)
  num             = 1
  slot_num        = var.slot_num
  plan            = azurerm_app_service_plan.linux.id
  subscription_id = var.subscription_id
  http2_enabled   = var.http2_enabled
  fx              = "compose"
  fx_version      = data.local_file.compose.content
  ip_restrictions = var.ip_restrictions
}

data "local_file" "compose" {
  filename = format("%s/docker-compose.yml", path.module)
}
