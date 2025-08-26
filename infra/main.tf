terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.30.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "7f44b397-03e8-463f-bcc4-9c1b2dcf4eac"
}

resource "azurerm_resource_group" "lucky" {
  name     = "john"
  location = "North Europe"
}

resource "azurerm_service_plan" "plan" {
  name                = "lucky-service-plan"
  location            = azurerm_resource_group.lucky.location
  resource_group_name = azurerm_resource_group.lucky.name
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "web" {
  name                = "lucky-web-app"
  location            = azurerm_resource_group.lucky.location
  resource_group_name = azurerm_resource_group.lucky.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      java_server         = "JAVA"
      java_version        = "21"
      java_server_version = "21"
    }
  }
}

