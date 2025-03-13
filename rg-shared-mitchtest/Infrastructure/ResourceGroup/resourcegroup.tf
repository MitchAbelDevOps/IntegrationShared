/**************************************************
Existing Resources
***************************************************/


/**************************************************
New Resources
***************************************************/
// Resource Group
resource "azurerm_resource_group" "resourceGroup" {
  name     = local.fullResourceGroupName
  location = var.location

  tags = local.tags
}

// TEMP AUE
resource "azurerm_resource_group" "resourceGroup-secondary" {
  count = var.createSecondaryRG ? 1 : 0
  
  name = "${var.resourceGroupName}-${var.resourceSuffix}-${var.environment}-aue"
  location = "australiaeast"

  tags = local.tags
}