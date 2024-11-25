/**************************************************
Existing Resources
***************************************************/

/**************************************************
New Resources
***************************************************/
// Log Analytics Workspace
// NOTE: We will change to targeting an existing instance in another subscription when it is provisioned, and remove this one
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "log-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  location            = var.location
  resource_group_name = local.fullResourceGroupName
  sku                 = "PerGB2018"
  retention_in_days   = 30

  lifecycle {
    prevent_destroy = false
  }
}

// Application Insights
resource "azurerm_application_insights" "shared_app_insight" {
  name                = "appi-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  location            = var.location
  resource_group_name = local.fullResourceGroupName
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace.id

  lifecycle {
    prevent_destroy = false
  }
}