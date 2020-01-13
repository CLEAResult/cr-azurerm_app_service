variable "rgid" {
  description = "RGID used for naming"
}

variable "location" {
  default     = "southcentralus"
  description = "Location for resources to be created"
}

variable "plan" {
  default     = ""
  description = "Full Azure App Service Plan resource ID.  Either 'plan' or 'plan_name' and 'plan_rg' must be set. 'Plan' takes precendence."
}

variable "plan_name" {
  default     = ""
  description = "Azure App Service Plan name.  Either 'plan' or 'plan_name' and 'plan_rg' must be set. 'Plan' takes precendence."
}

variable "plan_rg" {
  default     = ""
  description = "Azure App Service Plan resource group name.  Either 'plan' or 'plan_name' and 'plan_rg' must be set. 'Plan' takes precendence."
}

variable "num" {
  default = 1
}

variable "slot_num" {
  default = 0
  description = "If set to a number greater than 0, create that many slots with generated names and the same configuration as the app. For now, this feature only support creating a slot on the first app service count (index 0).  If var.num is greater than 1, all slots will still be created on the index 0 app."
}

variable "name_prefix" {
  default     = ""
  description = "Allows users to override the standard naming prefix.  If left as an empty string, the standard naming conventions will apply."
}

variable "environment" {
  default     = "dev"
  description = "Environment used in naming lookups"
}

variable "rg_name" {
  description = "Resource group name"
}

variable "subscription_id" {
  description = "Prompt for subscription ID"
}

variable "http2_enabled" {
  description = "Is HTTP2 Enabled on this App Service? Defaults to false."
}

variable "ip_restrictions" {
  type        = list(string)
  default     = []
  description = "A list of IP addresses in CIDR format specifying Access Restrictions."
}

variable "ftps_state" {
  description = "State of FTP / FTPS service for this App Service. Possible values include: AllAllowed, FtpsOnly and Disabled."
  default = "FtpsOnly"
}

variable "app_settings" {
  type        = map(string)
  default     = {}
  description = "Set app settings. These are avilable as environment variables at runtime."
}

variable "enable_storage" {
  type = bool
  default = false
  description = "Per Microsoft docs: If WEBSITES_ENABLE_APP_SERVICE_STORAGE setting is unspecified or set to true, the /home/ directory will be shared across scale instances, and files written will persist across restarts. Explicitly setting WEBSITES_ENABLE_APP_SERVICE_STORAGE to false will disable the mount."
}

variable "key_vault_id" {
  type        = string
  default     = ""
  description = "The ID of an existing Key Vault. Required if `secret_name` is set."
}

variable "secret_name" {
  type        = string
  default     = ""
  description = "Secret name to retrieve from var.key_vault_id. Uses Key Vault references as values for app settings."
}

variable "win_php_version" {
  default     = "7.2"
  description = "Used to select Windows web app PHP version.  Valid values are 5.6, 7.0, 7.1, or 7.2.  Default is 7.2."
}

variable "fx" {
  default     = "php"
  description = "Used for Linux web app framework selection - ignored on Windows web apps. Default is PHP. Valid values for non-container deployments are `php` or `node`. Valid values for container deployments are: `docker`, `compose` or `kube`."
}

variable "fx_version" {
  default     = "7.2"
  description = "Used for Linux web app framework selection - ignored on Windows web apps.  Valid values are dependent on the `fx` variable value. If `fx` is `php`, `fx_value` would need to be a supported Azure web app PHP version (ie: 5.6, 7.0, 7.2). Similar if `fx` is `node`. If `fx` is `docker`, `fx_version` should specify a valid container image name such as `appsvcsample/python-helloworld:latest`. Lastly, if `fx` is either `compose` or `kube`, `fx_version` should be a valid YAML configuration."
}

variable "port" {
  type        = string
  default     = null
  description = "The value of the expected container port number."
}

variable "docker_registry_username" {
  type        = string
  default     = null
  description = "The container registry username."
}

variable "docker_registry_url" {
  type        = string
  default     = "https://index.docker.io"
  description = "The container registry url."
}

variable "docker_registry_password" {
  type        = string
  default     = null
  description = "The container registry password."
}

variable "azure_registry_name" {
  type        = string
  default     = ""
  description = "The container registry name if using Azure Container Registry. Used with azure_registry_rg, will fill in the user/password using a terraform data source."
}

variable "azure_registry_rg" {
  type        = string
  default     = ""
  description = "The container registry resource group name if using Azure Container Registry. Used with azure_registry_name, will fill in the user/password using a terraform data source."
}

variable "start_time_limit" {
  type        = number
  default     = 230
  description = "Configure the amount of time (in seconds) the app service will wait before it restarts the container."
}

variable "command" {
  type        = string
  default     = ""
  description = "A command to be run on the container."
}

variable "storage_accounts" {
  type = list(object({
    name         = string
    type         = string
    account_name = string
    share_name   = string
    access_key   = string
    mount_path   = string
  }))
  default     = []
  description = "Used for Azure Linux web app Bring Your Own storage. Mounts an Azure Blob container or Azure Files share to a specific folder path on the web app."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the web app."
}

# Compute default name values
locals {
  plan_name = var.plan != "" ? split("/", var.plan)[8] : var.plan_name
  plan_rg = var.plan != "" ? split("/", var.plan)[4] : var.plan_rg
  plan = var.plan != "" ? var.plan : format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/serverFarms/%s", data.azurerm_client_config.current.subscription_id, var.plan_rg, var.plan_name)

  env_id = lookup(module.naming.env-map, var.environment, "env")
  type   = lookup(module.naming.type-map, "azurerm_app_service", "typ")

  rg_type = lookup(module.naming.type-map, "azurerm_resource_group", "typ")

  default_rgid        = var.rgid != "" ? var.rgid : "norgid"
  default_name_prefix = format("c%s%s", local.default_rgid, local.env_id)

  name_prefix = var.name_prefix != "" ? var.name_prefix : local.default_name_prefix
  name        = format("%s%s", local.name_prefix, local.type)

  docker_registry_url  = var.docker_registry_url != "" ? var.docker_registry_url : var.azure_registry_name != "" && var.azure_registry_rg != "" ? data.azurerm_container_registry.acr[0].login_server : ""
  docker_registry_username  = var.docker_registry_username != "" ? var.docker_registry_username : var.azure_registry_name != "" && var.azure_registry_rg != "" ? data.azurerm_container_registry.acr[0].admin_username : ""
  docker_registry_password  = var.docker_registry_password != "" ? var.docker_registry_password : var.azure_registry_name != "" && var.azure_registry_rg != "" ? data.azurerm_container_registry.acr[0].admin_password : ""

  app_settings = {
    "WEBSITES_CONTAINER_START_TIME_LIMIT" = var.start_time_limit
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = var.enable_storage
    "WEBSITES_PORT"                       = var.port
    "DOCKER_REGISTRY_SERVER_USERNAME"     = local.docker_registry_username
    "DOCKER_REGISTRY_SERVER_URL"          = local.docker_registry_url
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = local.docker_registry_password
  }

  fx = upper(var.fx)

  supported_fx = {
    COMPOSE = true
    DOCKER  = true
    KUBE    = true
    NODE    = true
    PHP     = true
  }
  check_supported_fx = local.supported_fx[local.fx]
  
  fx_version = local.fx == "COMPOSE" || local.fx == "KUBE" ? base64encode(var.fx_version) : var.fx_version

  linux_fx_version = data.azurerm_app_service_plan.app.kind == "Windows" ? null : format("%s|%s", local.fx, local.fx_version)

  secure_app_settings = var.secret_name != "" && var.key_vault_id != "" ? {
    for secret in data.azurerm_key_vault_secret.app:
    replace(secret.name, "-", "_") => format("@Microsoft.KeyVault(SecretUri=%s)", secret.id)
  } : {}

  ip_restrictions = [
    for prefix in var.ip_restrictions : {
      ip_address  = split("/", prefix)[0]
      subnet_mask = cidrnetmask(prefix)
    }
  ]
}

# This module provides a data map output to lookup naming standard references
module "naming" {
  source = "git::https://github.com/CLEAResult/cr-azurerm-naming.git?ref=v1.0.1"
}

