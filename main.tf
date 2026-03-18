resource "azapi_resource" "this" {
  type                      = "Microsoft.Network/applicationGateways@2025-03-01"
  name                      = var.name
  parent_id                 = var.parent_id
  ignore_null_property      = true
  schema_validation_enabled = true
  location                  = var.location
  body                      = local.resource_body
  tags                      = var.tags
  dynamic "identity" {
    for_each = local.managed_identities.system_assigned_user_assigned
    content {
      type         = identity.value.type
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }
  response_export_values = [
    "identity.principalId",
    "identity.tenantId",
  ]

  list_unique_id_property = {
    "properties.frontendIPConfigurations"       = "name"
    "properties.backendAddressPools"            = "name"
    "properties.backendHttpSettingsCollection"  = "name"
    "properties.frontendPorts"                  = "name"
    # For nested lists like backendAddresses (no name field):
    "properties.backendAddressPools.properties.backendAddresses" = "ipAddress"
  }

  ignore_other_items_in_list = [
    "properties.frontendIPConfigurations",
    "properties.backendAddressPools",
    "properties.backendHttpSettingsCollection",
    "properties.frontendPorts",
  ]  
}
