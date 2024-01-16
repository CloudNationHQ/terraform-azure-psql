This example illustrates the default postgresql setup, in its simplest form.

## Usage: default

```hcl
module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 0.1"

  instance = {
    name           = module.naming.postgresql_server.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}
```

Additionally, for certain scenarios, the example below highlights the ability to use multiple psql instances.

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

The module uses a local to iterate, generating a storage account for each key.

```hcl
locals {
  psql = {
      }
    }
  }
}
```

