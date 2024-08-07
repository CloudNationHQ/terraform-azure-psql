This example highlights configuring virtual network rules for optimized network integration.

## Usage

```hcl
module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 1.0"

  naming = local.naming

  instance = {
    name           = module.naming.postgresql_server.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    fw_rules = {
      sales = {
        start_ip_address = "10.20.30.1"
        end_ip_address   = "10.20.30.255"
      }
      hr = {
        start_ip_address = "10.20.31.1"
        end_ip_address   = "10.20.31.255"
      }
    }
  }
}
```
