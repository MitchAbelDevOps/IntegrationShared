/**************************************************
Existing Resources
***************************************************/
data "azurerm_virtual_network" "tewheke_vnet" {
  name                = "vnet-integration-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name = "${var.networkingResourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
}

data "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "snet-prep-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name  = "${var.networkingResourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  virtual_network_name = "vnet-integration-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
}

data "azurerm_private_dns_zone" "servicebus_private_dns_zone" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = "${var.networkingResourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
}

data "azurerm_user_assigned_identity" "servicebus_readwrite" {
  name                = "uami-sb-readwrite-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name = local.fullResourceGroupName
}

//TODO Update to the shared LAWS in the security sub when it is provisioned and network routing is in place
data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "log-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name = local.fullResourceGroupName
}

/**************************************************
New Resources
***************************************************/
// Service Bus
resource "azurerm_servicebus_namespace" "servicebus" {
  name                = "sb-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  location            = var.location
  resource_group_name = local.fullResourceGroupName
  sku                 = var.serviceBusSku
  network_rule_set {
    default_action                = "deny"
    public_network_access_enabled = var.serviceBusAllowPublicAccess
    trusted_services_allowed      = true
    ip_rules                      = var.servceBusIPRules
  }
}

// Service Bus Diagnostics
resource "azurerm_monitor_diagnostic_setting" "servicebus_diagnostics" {
  name                = "sb-diagnosticlog-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  target_resource_id = azurerm_servicebus_namespace.servicebus

  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category_group = "allLogs"
  }
}

// ServiceBus Private Endpoint
// NOTE: Deploys in networking resource group, not the shared
module "servicebus_private_endpoint" {
  source                         = "git@github.com:TerraformModules/PrivateEndpoints"
  name                           = "pep-sb-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  location                       = var.location
  resource_group_name            = "${var.networkingResourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  subnet_id                      = data.azurerm_subnet.private_endpoint_subnet.id
  private_connection_resource_id = azurerm_servicebus_namespace.servicebus.id
  is_manual_connection           = false
  subresource_name               = "namespace"
  private_dns_zone_group_name    = "ServiceBusPrivateDnsZoneGroup"
  private_dns_zone_group_ids     = [data.azurerm_private_dns_zone.servicebus_private_dns_zone.id]
}

// Service Bus Data Sender role assignment for User Assigned Managed Identity
resource "azurerm_role_assignment" "uami_role_assignment" {
  scope                = azurerm_servicebus_namespace.servicebus
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = data.azurerm_user_assigned_identity.servicebus_readwrite.principal_id
}

// Service Bus Data Receiver role assignment for User Assigned Managed Identity
resource "azurerm_role_assignment" "uami_role_assignment" {
  scope                = azurerm_servicebus_namespace.servicebus
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = data.azurerm_user_assigned_identity.servicebus_readwrite.principal_id
}