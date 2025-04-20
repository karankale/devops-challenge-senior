# Azure Container App Terraform

## Prerequisites

- Terraform >= 1.0.0
- Azure CLI ([install docs](https://docs.microsoft.com/cli/azure/install-azure-cli))
- An Azure Subscription
- [Optional] Service Principal or Azure CLI authentication: `az login`

## Setup

1. Clone or unzip this repository.
2. Login to Azure:
   ```sh
   az login
   ```
3. [Optional] Set subscription:
   ```sh
   az account set --subscription "<subscription-id>"
   ```

## Deployment

```sh
cd path/to/azure-container-app-terraform
terraform init
terraform apply
```

- When prompted, you can override `prefix` or `location` variables.
- Defaults: `prefix="aca"`, `location="UK South"`

## Outputs

- `container_app_url`: The public URL of the Container App (e.g., `https://aca-app.<region>.azurecontainerapps.io`)

## Assumptions

- You have sufficient permissions to create Resource Groups, Log Analytics Workspaces, and Container Apps.
- Azure CLI is authenticated.
- No existing resources conflict with the names `<prefix>-rg`, `<prefix>-law`, etc.
