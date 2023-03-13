output "kube_config_raw" {
  value = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}
