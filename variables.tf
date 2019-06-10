variable "rgid" {
  description = "RGID used for naming"
}

variable "location" {
  default     = "southcentralus"
  description = "Location for resources to be created"
}

variable "plan" {
  description = "Azure App Service Plan resource ID"
}

variable "count" {
  default = "1"
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

variable "fx" {
  default     = "PHP"
  description = "Used for Linux web app framework selection - ignored on Windows web apps.  Default is PHP. Valid options are shown in the templates at https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/app-service."
}

variable "fx_version" {
  default     = "7.2"
  description = "Used for Linux web app framework selection - ignored on Windows web apps.  Valid values refer to PHP or NodeJS version, or can specify a Docker hub path and version tag."
}

variable "win_php_version" {
  default     = "7.2"
  description = "Used to select Windows web app PHP version.  Valid values are 5.6, 7.0, 7.1, or 7.2.  Default is 7.2."
}

variable "subscription_id" {
  description = "Prompt for subscription ID"
}

# Compute default name values
locals {
  env_id = "${lookup(module.naming.env-map, var.environment, "ENV")}"
  type   = "${lookup(module.naming.type-map, "azurerm_app_service", "TYP")}"

  rg_type = "${lookup(module.naming.type-map, "azurerm_resource_group", "TYP")}"

  default_rgid        = "${var.rgid != "" ? var.rgid : "NORGID"}"
  default_name_prefix = "c${local.default_rgid}${local.env_id}"

  name_prefix = "${var.name_prefix != "" ? var.name_prefix : local.default_name_prefix}"
  name        = "${local.name_prefix}${local.type}"
}

# This module provides a data map output to lookup naming standard references
module "naming" {
  source = "git::https://github.com/CLEAResult/cr-azurerm-naming.git?ref=v1.0.1"
}
