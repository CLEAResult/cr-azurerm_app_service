package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformServer(t *testing.T) {
	t.Parallel()

	targetedTfOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "./fixture",
		Targets:      []string{"azurerm_container_registry.acr"},
	}

	// This will init and apply the targeted resources and fail
	// the test if there are any errors
	terraform.InitAndApply(t, targetedTfOptions)

	// Read the container registry name and resource group from
	// the -target plan and supply to module test
	name := terraform.Output(t, targetedTfOptions, "azure_registry_name")
	rg := terraform.Output(t, targetedTfOptions, "azure_registry_rg")

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "./fixture",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"azure_registry_name": name,
			"azure_registry_rg":   rg,
		},
	}

	// This will apply the resources and fail the test if there
	// are any errors
	terraform.Apply(t, terraformOptions)

	// At the end of the test, clean up any resources that were created
	terraform.Destroy(t, terraformOptions)
}
