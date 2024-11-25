/**************************************************
Existing Resources
***************************************************/


/**************************************************
New Resources
***************************************************/
// Starter product for APIM testing
// NOTE: This can reference APIM as it's in the same directory as the service Terraform file
resource "azurerm_api_management_product" "starter" {
  display_name        = "Starter"
  product_id          = "starter"
  api_management_name = azurerm_api_management.apim_internal.name
  resource_group_name = azurerm_api_management.apim_internal.resource_group_name
  published           = true

  lifecycle {
    prevent_destroy = false
  }
}

// Subscription Key for Echo API product
resource "azurerm_api_management_subscription" "echo" {
  api_management_name = azurerm_api_management.apim_internal.name
  resource_group_name = azurerm_api_management.apim_internal.resource_group_name
  product_id          = azurerm_api_management_product.starter.id
  display_name        = "Echo API"
  allow_tracing       = false
  state               = "active"

  lifecycle {
    prevent_destroy = false
  }
}