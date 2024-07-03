This example details customer managed key integration.

## Usage

```hcl
module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 0.6"

  naming = local.naming

  instance = {
    name           = module.naming.postgresql_server.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    geo_redundant_backup = true

    cmk = {
      primary = {
        key_vault_id     = module.kv.vault.id
        key_vault_key_id = module.kv.keys.psql.id
      },
      backup = {
        key_vault_id     = module.kv_backup.vault.id
        key_vault_key_id = module.kv_backup.keys.psql.id
      }
    }
  }
}
```
