/**************************************************
Existing Resources
***************************************************/


/**************************************************
New Resources
***************************************************/
// KeyVault Secret Reader UAMI
resource "azurerm_user_assigned_identity" "keyvault_secret_reader" {
  name                = "uami-kv-reader-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name = local.fullResourceGroupName
  location            = var.location
}

// ServiceBus Data ReadWrite UAMI
resource "azurerm_user_assigned_identity" "servicebus_readwrite" {
  name                = "uami-sb-readwrite-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name = local.fullResourceGroupName
  location            = var.location
}

// Azure Container Registry UAMI
resource "azurerm_user_assigned_identity" "acr_pull" {
  name                = "uami-acr-pull-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name = local.fullResourceGroupName
  location            = var.location
}