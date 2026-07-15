locals {
  user_assigned_identities = flatten([
    for uai_key, uai in var.instance.customer_managed_key != null ? var.instance.customer_managed_key : {} :
    {
      key                              = uai_key
      key_vault_id                     = uai.key_vault_id
      user_assigned_identity_principal = uai.principal_id
    } if uai != null
  ])

  ad_auth_enabled = var.instance.authentication.active_directory_auth_enabled == true

  has_cmk = var.instance.customer_managed_key != null && (
    var.instance.customer_managed_key.primary != null || var.instance.customer_managed_key.backup != null
  )

  identity_type = local.has_cmk && local.ad_auth_enabled ? "SystemAssigned, UserAssigned" : local.ad_auth_enabled ? "SystemAssigned" : local.has_cmk ? "UserAssigned" : null
}
