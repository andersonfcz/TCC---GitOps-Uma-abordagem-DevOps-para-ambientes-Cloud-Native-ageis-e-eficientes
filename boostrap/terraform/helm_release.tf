resource "helm_release" "ingress_controller" {
  name       = "nginx-ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.5.2"
  namespace = "nginx"

  depends_on = [
    azurerm_kubernetes_cluster.main
  ]
}

resource "helm_release" "argocd_operator" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.25.0"
  namespace = "argo-cd"
  create_namespace = true

  values = [ 
    "${file("${path.module}/../helm/argocd/values.yaml")}"
  ]

  depends_on = [
    azurerm_kubernetes_cluster.main
  ]
}

resource "kubectl_manifest" "argocd_sync_app" {
  yaml_body = file("${path.module}/../helm/argocd/applicationset.yaml")

  depends_on = [
    helm_release.argocd_operator
  ]
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "6.14.3"
  namespace = "external-dns"
  create_namespace = true

  values = [ 
    file("${path.module}/../helm/externaldns/values.yaml")
  ]

  set {
    name = "provider"
    value = "azure"
  }
  
  set {
    name = "azure.resourceGroup"
    value = var.resource_name
  }

  set {
    name = "azure.tenantId"
    value = var.tenant_id
  }

  set {
    name = "azure.subscriptionId"
    value = var.subscription_id
  }

  set {
    name = "azure.useManagedIdentityExtension"
    value = true
  }

  set {
    name = "domainFilters"
    value = var.dns_name
  }

  depends_on = [
    azurerm_kubernetes_cluster.main
  ]
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.11.0"
  namespace = "cert-manager"
  create_namespace = true

  values = [ 
    "${file("${path.module}/../helm/argocd/values.yaml")}"
  ]

  depends_on = [
    azurerm_kubernetes_cluster.main
  ]
}