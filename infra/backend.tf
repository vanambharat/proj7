terraform {
  backend "azurerm" {
    resource_group_name  = "john"  # same as above
    storage_account_name = "yourstorageacct"  # must be globally unique
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

