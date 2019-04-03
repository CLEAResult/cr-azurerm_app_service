# cr-azurerm_app_service

Creates an azure app service web app on an existing app service plan.

# Required Input Variables

* `plan` - Azure app service plan resource ID full path
* `rg_name` - Resource group name - doesn't have to be in the same resource group as the plan

Note that both the plan and resource group in `rg_name` must exist prior to creating the web app.  See https://github.com/CLEAResult/cr-terraform-examples for a working example.

# Example

```
variable "plan" {
  default = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resourcegroupname/providers/Microsoft.Web/serverfarms/planname"
}

variable "rg_name" {
  default = "resourcegroupname"
}

module "web" {
  source = "git::ssh://git@github.com/clearesult/cr-azurerm_app_service.git"
  rg_name = "${var.rg_name}"
  plan = "${var.plan}"
}
```
