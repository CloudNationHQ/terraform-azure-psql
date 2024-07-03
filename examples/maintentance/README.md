This example highlights maintenance usage.

## Usage

```hcl
module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 0.6"

  instance = {
    name           = module.naming.postgresql_server.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    maintenance = {
      day_of_week  = "0"
      start_hour   = "20"
      start_minute = "30"
    }
  }
}
```
