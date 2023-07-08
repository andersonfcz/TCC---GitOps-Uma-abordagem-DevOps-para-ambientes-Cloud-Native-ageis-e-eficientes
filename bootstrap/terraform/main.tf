resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.resource_group_name}-aks-cluster"
  location            = var.azure_region
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.resource_group_name}-k8s"


  default_node_pool {
    name            = "gitopspool"
    node_count      = var.node_count
    vm_size         = var.vm_size
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

}

data "azurerm_kubernetes_cluster" "main" {
  name                = azurerm_kubernetes_cluster.main.name
  resource_group_name = azurerm_kubernetes_cluster.main.resource_group_name
}

data "azurerm_dns_zone" "tcc_unicarioca" {
  name                = var.dns_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "external_dns" {
  scope                            = data.azurerm_dns_zone.tcc_unicarioca.id
  role_definition_name             = "DNS Zone Contributor"
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}

# comment
