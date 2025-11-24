locals {
  user_assigned_identities = flatten([
    for uai_key, uai in var.instance.customer_managed_key != null ? var.instance.customer_managed_key : {} :
    {
      key              = uai_key
      naming_suffix    = uai_key == "backup" ? "-bck" : ""
      key_vault_id     = uai.key_vault_id
      key_vault_key_id = uai.key_vault_key_id
    } if uai != null
  ])
}
