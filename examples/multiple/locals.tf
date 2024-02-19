locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["postgresql_database"]
}

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
