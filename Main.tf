# main.tf
 
# Configuration du provider Azure
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
# Ajouter la documentation pour la ressource random_integer
# Documentation de la ressource random_integer : https://github.com/hashicorp/terraform-provider-random/blob/main/docs/resources/integer.md
 
# Génération d'un nombre aléatoire
resource "random_integer" "random_num" {
  min = 1000
  max = 9999
}
 
# Création du groupe de ressources
resource "azurerm_resource_group" "my_resource_group" {
  name     = "rg-cheung-${random_integer.random_num.result}"
  location = "francecentral" # Remplacez par votre région Azure préférée
}
 
# Création du plan App Service
resource "azurerm_app_service_plan" "my_app_service_plan" {
  name                = "asp-cheung-${random_integer.random_num.result}"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
 
  sku {
    tier = "Basic"
    size = "B1"
  }
}
 
# Création de l'application web
resource "azurerm_app_service" "my_web_app" {
  name                = "rg-cheung-${random_integer.random_num.result}"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  app_service_plan_id = azurerm_app_service_plan.my_app_service_plan.id
 
  site_config {
    java_version = "1.8"
    java_container = "JAVA"
  
  }
}
