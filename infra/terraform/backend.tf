terraform {
  backend "azurerm" {
    resource_group_name  = "${var.backend_resource_group}"
    storage_account_name = "${var.backend_storage_account}"
    container_name       = "tfstate"
    key                  = "async-ai/terraform.tfstate"
  }
}
