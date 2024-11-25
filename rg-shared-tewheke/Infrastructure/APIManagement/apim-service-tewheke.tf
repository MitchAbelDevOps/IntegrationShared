/**************************************************
Existing Resources
***************************************************/
data "azurerm_subnet" "apim_subnet" {
  name                 = "snet-apim-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name  = "${var.networkingResourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  virtual_network_name = "vnet-integration-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
}

data "azurerm_application_insights" "shared_app_insight" {
  name                = "appi-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name = local.fullResourceGroupName
}

data "azurerm_user_assigned_identity" "keyvault_secret_reader" {
  name                = "uami-kv-reader-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name = local.fullResourceGroupName
}

data "azurerm_user_assigned_identity" "servicebus_readwrite" {
  name                = "uami-sb-readwrite-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name = local.fullResourceGroupName
}

/**************************************************
New Resources
***************************************************/
// API Management Internal Mode
resource "azurerm_api_management" "apim_internal" {
  name                 = "apim-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  location             = var.location
  resource_group_name  = local.fullResourceGroupName
  publisher_name       = var.publisherName
  publisher_email      = var.publisherEmail
  virtual_network_type = "Internal"

  sku_name = var.apimSkuName

  virtual_network_configuration {
    subnet_id = data.azurerm_subnet.apim_subnet.id
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      "${azurerm_user_assigned_identity.keyvault_secret_reader.id}",
      "${azurerm_user_assigned_identity.servicebus_readwrite.id}"
    ]
  }

  lifecycle {
    prevent_destroy = false
  }
}

// Explicit named value for app insights instrumentation key so we don't get a random GUID for the name
resource "azurerm_api_management_named_value" "appinsights_key" {
  name                = "appinsights-key"
  resource_group_name = local.fullResourceGroupName
  api_management_name = azurerm_api_management.apim_internal.name
  display_name        = "appinsights-key"
  value               = data.azurerm_application_insights.shared_app_insight.instrumentation_key
  secret              = false
}

// API Management Logger
resource "azurerm_api_management_logger" "apim_logger" {
  name                = "apim-logger"
  resource_group_name = local.fullResourceGroupName
  api_management_name = azurerm_api_management.apim_internal.name
  resource_id         = data.azurerm_application_insights.shared_app_insight.id
  application_insights {
    instrumentation_key = "{{appinsights-key}}"
  }
}

