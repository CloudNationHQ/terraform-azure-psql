This section outlines vnet integration for improved database connectivity.

## Usage

```hcl
instance = object({
  name                          = string
  location                      = string
  resource_group                = string
  public_network_access_enabled = optional(bool, true)

  delegated_subnet_id  = optional(string)
  private_dns_zone_id  = optional(string)
})
```
