This readme contains multiple examples in how to setup the AD admin.
In these examples, the principal_type field is used to specify whether a User should be used for authentication. By default, if principal_type is not specified, Terraform assumes that a Service Principal (SP) is being used. This is because in most cases, Terraform is run in an automated environment under a Service Principal.

However, if you're running Terraform under a User account and want to use that User for authentication, then you need to explicitly set principal_type = "User".

The object_id and principal_name fields are optional and are used to specify a particular User or Service Principal. If they are not provided, then the currently logged-in Service Principal (or User, if principal_type = "User") is used.

## Usage - "User" (current): AD admin will be set as the current logged in user under which Terraform runs. 
This configuration sets the Azure Active Directory (AD) admin as the user account which is currently logged into Terraform. 
This means the logged-in user's credentials will be used to authenticate to the Azure PostgreSQL instance.

```hcl
module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 0.6"

  instance = {
    name           = module.naming.postgresql_server.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    admin_password = module.kv.secrets.psql-admin-password.value
    key_vault_id   = module.kv.vault.id

    enabled = {
      ad_auth = true
      pw_auth = true
    }

    ad_admin = {
      principal_type = "User"
    }
  }
}
```

## Usage - "ServicePrincipal" (current): AD admin will be set as the current logged in SP under which Terraform runs. 
This configuration sets the AD admin as the Service Principal (SP) that is currently being used by Terraform. 
This means that the credentials of the current Service Principal will be used for authentication with the Azure PostgreSQL instance.

```hcl
module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 0.1"

  instance = {
    name           = module.naming.postgresql_server.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    admin_password = module.kv.secrets.psql-admin-password.value
    key_vault_id   = module.kv.vault.id

    enabled = {
      ad_auth = true
      pw_auth = true
    }
  }
}

In this example, principal_type = "ServicePrincipal" is not explicitly set. This is because when this field is not provided, 
Terraform will default to using the currently logged-in Service Principal.
```

## Usage - Explicit "User" specified
This configuration sets a specific user as the AD admin for the Azure PostgreSQL instance. The object_id is the unique identifier of the user in Azure AD, and principal_name is the user's login name. This user will be granted access to authenticate to the Azure PostgreSQL instance.

```hcl
module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 0.1"

  instance = {
    name           = module.naming.postgresql_server.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    admin_password = module.kv.secrets.psql-admin-password.value
    key_vault_id   = module.kv.vault.id

    enabled = {
      ad_auth = true
      pw_auth = true
    }

    ad_admin = {
      principal_type = "User"
      object_id      = "7e81d148-0000-0000-0000-4ae000b6406e"
      principal_name = "john.doe@sometenant.onmicrosoft.com"
    }
  }
}

```

## Usage - Explicit "ServicePrincipal" specified
This configuration sets a specific Service Principal as the AD admin. The object_id is the unique identifier of the Service Principal in Azure AD, and principal_name is the (display) name of the Service Principal. This Service Principal will be granted access to authenticate to the Azure PostgreSQL instance.

```hcl
module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 0.1"

  instance = {
    name           = module.naming.postgresql_server.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    admin_password = module.kv.secrets.psql-admin-password.value
    key_vault_id   = module.kv.vault.id

    enabled = {
      ad_auth = true
      pw_auth = true
    }

    ad_admin = {
      principal_type = "ServicePrincipal"
      object_id      = "7e81d148-0000-0000-0000-4ae000b6406e"
      principal_name = "TerraformPsql"
    }
  }
}

```