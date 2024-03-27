terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "random_integer" "random_suffix" {
  min     = 1000
  max     = 9999
  # Vous pouvez ajuster min et max selon vos besoins pour générer des nombres uniques.
  # Par exemple, pour garantir une unicité dans un contexte plus large, vous pourriez vouloir utiliser un nombre plus grand.
}

resource "azurerm_resource_group" "example" {
  name     = "rg-{remplacez_par_votre_nom}-${random_integer.random_suffix.result}"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "example" {
  name                = "app-service-plan-{remplacez_par_votre_nom}-${random_integer.random_suffix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_linux_web_app" "example" {
  name                = "web-app-{remplacez_par_votre_nom}-${random_integer.random_suffix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    java_version      = "1.8"
    linux_fx_version  = "JAVA|8-jre8"
  }
}
