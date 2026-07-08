This deploys an Azure PostgreSQL Flexible Server with both Active Directory (AD) and Password authentication enabled.

When `active_directory_auth_enabled = true`, the module automatically assigns a `SystemAssigned` managed identity to the server and grants it the **Directory Readers** Entra role. This role is required for the server to resolve Entra user identities at login time.

**Note**: The Terraform principal running this must have either the `RoleManagement.ReadWrite.Directory` application role (for a Service Principal) or the `Privileged Role Administrator` / `Global Administrator` directory role (for a User Principal) to assign Directory Readers to the managed identity.