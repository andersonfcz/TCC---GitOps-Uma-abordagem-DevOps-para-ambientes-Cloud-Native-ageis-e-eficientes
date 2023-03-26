terraform {
  backend "azurerm" {
    resource_group_name  = "tcc-unicarioca-gitops"
    storage_account_name = "tccterraformbackend"
    container_name       = "tfstate"
    key                  = "aks.terraform.tfstate"
  }
}

