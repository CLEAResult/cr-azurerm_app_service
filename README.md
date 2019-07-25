# cr-azurerm_app_service

Creates an azure app service web app on an existing app service plan.

# Required Input Variables

* `plan` - Azure app service plan resource ID full path
* `rg_name` - Resource group name - doesn't have to be in the same resource group as the plan

Note that both the plan and resource group in `rg_name` must exist prior to creating the web app.  See https://github.com/CLEAResult/cr-terraform-examples for a working example.

Also, the location variable must match the location where the plan exists. Otherwise, you will get an error like the following, even though the reource and the managed identity will still be created: 

`A resource with the same name cannot be created in location 'Central US'. Please select a new resource name."`

# Example

```
variable "plan" {
  default = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resourcegroupname/providers/Microsoft.Web/serverfarms/planname"
}

variable "rg_name" {
  default = "resourcegroupname"
}

module "appservice" {
  source          = "git::ssh://git@github.com/clearesult/cr-azurerm_app_service.git"
  rg_name         = var.rg_name
  rgid            = var.rgid
  environment     = var.environment
  location        = var.location
  num             = 1
  slot_num        = var.slot_num
  plan            = var.plan
  subscription_id = var.subscription_id
  http2_enabled   = var.http2_enabled
}
```
