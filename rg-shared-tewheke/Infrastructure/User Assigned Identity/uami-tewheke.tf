/**************************************************
Existing Resources
***************************************************/


/**************************************************
New Resources
***************************************************/
// KeyVault Secret Reader UAMI
resource "azurerm_user_assigned_identity" "keyvault_secret_reader" {
  name                = "uami-kv-reader-${var.resourceSuffix}"
  resource_group_name = var.resourceGroupName
  location            = var.location
}

// ServiceBus Data ReadWrite UAMI
resource "azurerm_user_assigned_identity" "servicebus_readwrite" {
  name                = "uami-sb-readwrite-${var.resourceSuffix}"
  resource_group_name = var.resourceGroupName
  location            = var.location
}