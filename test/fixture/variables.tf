variable "resource_group_name" {}

variable "rgid" {}

variable "plan" {
  description = "Azure App Service Plan resource ID (must already exist)"
}

variable "environment" {}

variable "location" {}

variable "create_date" {}

variable "subscription_id" {}

variable "tenant_id" {}

variable "http2_enabled" {
  default = "true"
}

variable "slot_num" {}

