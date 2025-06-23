/**************************************************
Existing Resources
***************************************************/
data "azurerm_user_assigned_identity" "sa_blob_reader" {
  name                = "uami-sa-blob-reader-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  resource_group_name = local.fullResourceGroupName
}

data "azurerm_subscription" "current" {}

/**************************************************
New Resources
***************************************************/
// Operations Email Action Group
// Only deploy npe/ppe/prd versions
resource "azurerm_monitor_action_group" "mitchtest_operations_email_actiongroup" {
  count               = var.environment == "dev" || var.environment == "stg" || var.environment == "prd" ? 1 : 0
  name                = "ag-mitchtest-${var.environmentGroup}-email-ops"
  resource_group_name = local.fullResourceGroupName
  location            = "Global"
  short_name          = "TW-OpsEmails"
  enabled             = true

  dynamic "email_receiver" {
    for_each = var.mitchtestOperationsEmailReceivers
    content {
      email_address           = email_receiver.value.email
      name                    = email_receiver.value.name
      use_common_alert_schema = true
    }
  }
}

// Operations Email Action Group
// Only deploy npe/ppe/prd versions
resource "azurerm_monitor_action_group" "mitchtest_itsm_actiongroup" {
  count               = var.environment == "dev" || var.environment == "stg" || var.environment == "prd" ? 1 : 0
  name                = "ag-mitchtest-${var.environmentGroup}-log-itsm-ticket"
  resource_group_name = local.fullResourceGroupName
  location            = "Global"
  short_name          = "TW-ITSM"
  enabled             = false
}