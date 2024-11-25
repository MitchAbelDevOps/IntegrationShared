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

data "azurerm_private_dns_zone" "keyvault_private_dns_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = "${var.networkingResourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
}

data "azurerm_user_assigned_identity" "keyvault_secret_reader" {
  name                = "uami-kv-reader-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name = local.fullResourceGroupName
}

//TODO Update to the shared LAWS in the security sub when it is provisioned and network routing is in place
data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "log-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name = local.fullResourceGroupName
}

data "azurerm_client_config" "current" {}

/**************************************************
New Resources
***************************************************/
// KeyVault
resource "azurerm_key_vault" "keyvault" {
  name                          = "kv-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  location                      = var.location
  resource_group_name           = local.fullResourceGroupName
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = var.keyVaultSku
  public_network_access_enabled = false
  enable_rbac_authorization     = true
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
}

// KeyVault Diagnostics
resource "azurerm_monitor_diagnostic_setting" "keyvault_diagnostics" {
  name                = "kv-diagnosticlog-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  target_resource_id = azurerm_key_vault.keyvault.id

  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id

  enabled_log {
    category_group = "allLogs"
  }
}

// KeyVault Private Endpoint
// NOTE: Deploys in networking resource group, not the shared
module "keyvault_private_endpoint" {
  source                         = "github.com/MitchAbelDevOps/DevOps//TerraformModules/PrivateEndpoints"
  name                           = "pep-kv-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  location                       = var.location
  resource_group_name            = "${var.networkingResourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  subnet_id                      = data.azurerm_subnet.private_endpoint_subnet.id
  private_connection_resource_id = azurerm_key_vault.keyvault.id
  is_manual_connection           = false
  subresource_name               = "vault"
  private_dns_zone_group_name    = "KeyVaultPrivateDnsZoneGroup"
  private_dns_zone_group_ids     = [data.azurerm_private_dns_zone.keyvault_private_dns_zone.id]
}

// KeyVault role assignment for GitHub service principal
resource "azurerm_role_assignment" "service_principal_role_assignment" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.githubServicePrincipalId
}

// KeyVault role assignment for User Assigned Managed Identity
resource "azurerm_role_assignment" "uami_role_assignment" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_user_assigned_identity.keyvault_secret_reader.principal_id
}