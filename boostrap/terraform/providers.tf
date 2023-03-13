provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
    client_id       = var.app_id
    client_secret   = var.password
    tenant_id       = var.tenant_id
}

provider "helm" {
  kubernetes {
    host     = azurerm_kubernetes_cluster.main.kube_config.0.host
    username = azurerm_kubernetes_cluster.main.kube_config.0.username
    password = azurerm_kubernetes_cluster.main.kube_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
  }
}

provider "kubectl" {
    host     = azurerm_kubernetes_cluster.main.kube_config.0.host
    username = azurerm_kubernetes_cluster.main.kube_config.0.username
    password = azurerm_kubernetes_cluster.main.kube_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
    load_config_file       = false
}

/* provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
    config_path = "~/.kube/config"
} */