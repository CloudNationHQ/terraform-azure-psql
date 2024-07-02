This example illustrates the default postgresql setup, in its simplest form.

## Usage: default

```hcl
module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 0.5"

  instance = {
    name           = module.naming.postgresql_server.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}
```

Additionally, for certain scenarios, the example below highlights the ability to use multiple instances.

## Usage: multiple

```hcl
module "postgresql" {
  source = "cloudnationhq/psql/azure"
  version = "~> 0.1"

  for_each = local.psql

  naming = local.naming
  instance = each.value
}
```

The module uses a local to iterate, generating a postgresql flexible server for each key.

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
