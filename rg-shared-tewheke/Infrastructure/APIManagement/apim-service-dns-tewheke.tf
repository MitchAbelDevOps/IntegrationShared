/**************************************************
Existing Resources
***************************************************/
data "azurerm_private_dns_zone" "api_gateway_dns_zone" {
  name                = "azure-api.net"
  resource_group_name = "${var.networkingResourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
}

data "azurerm_private_dns_zone" "old_developer_portal_dns_zone" {
  name                = "portal.azure-api.net"
  resource_group_name = "${var.networkingResourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
}

data "azurerm_private_dns_zone" "new_developer_portal_dns_zone" {
  name                = "developer.azure-api.net"
  resource_group_name = "${var.networkingResourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
}

data "azurerm_private_dns_zone" "mgmt_portal_dns_zone" {
  name                = "management.azure-api.net"
  resource_group_name = "${var.networkingResourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
}
data "azurerm_private_dns_zone" "apim_git_dns_zone" {
  name                = "scm.azure-api.net"
  resource_group_name = "${var.networkingResourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
}

/**************************************************
New Resources
***************************************************/
// Explicit A record entries for APIM endpoints
// NOTE: These are added to the DNS zones in the networking resource group. We need to do this as we are not creating private endpoints with zone groups, and APIM is deployed in internal mode
resource "azurerm_private_dns_a_record" "gateway_record" {
  name                = "integration-apim-gateway"
  zone_name           = data.azurerm_private_dns_zone.api_gateway_dns_zone.name
  resource_group_name = var.networkingResourceGroupName
  ttl                 = 36000
  records             = azurerm_api_management.apim_internal.private_ip_addresses

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_private_dns_a_record" "old_developer_portal_record" {
  name                = "integration-apim-portal"
  zone_name           = data.azurerm_private_dns_zone.old_developer_portal_dns_zone.name
  resource_group_name = var.networkingResourceGroupName
  ttl                 = 300
  records             = azurerm_api_management.apim_internal.private_ip_addresses

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_private_dns_a_record" "new_developer_portal_record" {
  name                = "integration-apim-developer"
  zone_name           = data.azurerm_private_dns_zone.new_developer_portal_dns_zone.name
  resource_group_name = var.networkingResourceGroupName
  ttl                 = 300
  records             = azurerm_api_management.apim_internal.private_ip_addresses

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_private_dns_a_record" "mgmt_portal_record" {
  name                = "integration-apim-management"
  zone_name           = data.azurerm_private_dns_zone.mgmt_portal_dns_zone.name
  resource_group_name = var.networkingResourceGroupName
  ttl                 = 300
  records             = azurerm_api_management.apim_internal.private_ip_addresses

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_private_dns_a_record" "apim_git_record" {
  name                = "integration-apim-scm"
  zone_name           = data.azurerm_private_dns_zone.apim_git_dns_zone.name
  resource_group_name = var.networkingResourceGroupName
  ttl                 = 300
  records             = azurerm_api_management.apim_internal.private_ip_addresses

  lifecycle {
    prevent_destroy = false
  }
}
