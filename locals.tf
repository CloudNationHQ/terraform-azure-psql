locals {
  user_assigned_identities = flatten([
    for uai_key, uai in var.instance.customer_managed_key != null ? var.instance.customer_managed_key : {} :
    {
      key                              = uai_key
      key_vault_id                     = uai.key_vault_id
      user_assigned_identity_principal = uai.principal_id
    } if uai != null
  ])
}
