This example highlights configuring virtual network rules for optimized network integration.

## Types

```hcl
instance = object({
  name           = string
  location       = string
  resource_group = string

  fw_rules = optional(map(object({
    start_ip_address = string
    end_ip_address   = string
  })))
})
```
