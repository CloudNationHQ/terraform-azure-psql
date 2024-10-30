This example illustrates the default postgresql setup, in its simplest form.

## Types

```hcl
instance = object({
  name           = string
  location       = string
  resource_group = string
})
```

Additionally, for certain scenarios, the example below highlights the ability to use multiple server instances.

## Usage: multiple

```hcl
module "postgresql" {
  source = "cloudnationhq/psql/azure"
  version = "~> 1.0"

  for_each = local.psql

  naming = local.naming
  instance = each.value
}
```

Below a local is used to iterate, generating a postgresql flexible server for each key.

```hcl
locals {
  instances = {
    inst1 = {
      name = "psql-demo-dev-1"
      databases = {
        user = { charset = "UTF8" }
      }
    }
    inst2 = {
      name = "psql-demo-dev-2"
      fw_rules = {
        sales = {
          start_ip_address = "10.20.30.1"
          end_ip_address   = "10.20.30.255"
        }
      }
    }
  }
}
```
