This section focuses on high availability configuration.

## Types

```hcl
instance = object({
  name           = string
  location       = string
  resource_group = string
  sku_name       = string
  zone           = number

  high_availability = optional(object({
    mode                      = optional(string, "SameZone")
    standby_availability_zone = number
  }))
})
```
