locals {
  user_assigned_identities = flatten([for uai_key, uai in coalesce(var.instance.customer_managed_key, {}) :
    {
      key              = uai_key
      naming_suffix    = uai_key == "backup" ? "-bck" : ""
      key_vault_id     = uai.key_vault_id
      key_vault_key_id = uai.key_vault_key_id
    } if var.instance.customer_managed_key != null
  ])
}

locals {
  databases = flatten([
    for db_key, db in var.instance.databases : {
      db_key    = db_key
      name      = coalesce(db.name, join("-", [var.naming.postgresql_database, db_key]))
      charset   = db.charset
      collation = db.collation
    }
  ])
}
