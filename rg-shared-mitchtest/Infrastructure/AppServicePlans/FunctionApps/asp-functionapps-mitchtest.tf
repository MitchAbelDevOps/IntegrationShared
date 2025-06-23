/**************************************************
Existing Resources
***************************************************/
data "azurerm_monitor_action_group" "operations_action_group" {
  name                = "ag-mitchtest-${var.environmentGroup}-email-ops"
  resource_group_name = local.actionGroupResourceGroupName
}

/**************************************************
New Resources
***************************************************/
// App Service Plan
// Update size to 'scale up'
resource "azurerm_service_plan" "appServicePlan" {
  name                = "asp-fa-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  location            = var.location
  resource_group_name = local.fullResourceGroupName

  os_type  = "Windows"
  sku_name = var.aspSkuSize

  tags = local.tags
}

// Add more to 'scale out'

// Metric Alert for CPU Usage > 80%
resource "azurerm_monitor_metric_alert" "appServicePlan_cpu_aler" {
  name                = "alert-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}-aspfacpu-usage-sev2"
  resource_group_name = local.fullResourceGroupName
  scopes              = [azurerm_service_plan.appServicePlan.id]
  description         = "CPU usage for ${azurerm_service_plan.appServicePlan.name} is above 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Web/serverfarms"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  auto_mitigate = true

  action {
    action_group_id = data.azurerm_monitor_action_group.operations_action_group.id
  }
}