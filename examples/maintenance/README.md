This example highlights maintenance usage.

## Types

```hcl
instance = object({
  name           = string
  location       = string
  resource_group = string

  maintenance_window = optional(object({
    day_of_week  = string
    start_hour   = string
    start_minute = string
  }))
})
```
