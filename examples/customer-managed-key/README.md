This example details customer managed key integration.

## Types

```hcl
instance = object({
  name                = string
  location            = string
  resource_group      = string

  geo_redundant_backup_enabled = optional(bool, false)

  customer_managed_key = optional(object({
    primary = object({
      key_vault_id     = string
      key_vault_key_id = string
    })
    backup = optional(object({
      key_vault_id     = string
      key_vault_key_id = string
    }))
  }))
})
```
