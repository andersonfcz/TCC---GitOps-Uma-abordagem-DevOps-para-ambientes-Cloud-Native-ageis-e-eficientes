resource "helm_release" "ingress_controller" {
  name       = "nginx-ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.5.2"
  namespace = "nginx"
  create_namespace = true

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
    templatefile(
      "${path.module}/../helm/externaldns/values.yaml",
      {
        RESOURCE_GROUP = var.resource_name,
        TENANT_ID = var.tenant_id,
        SUBSCRIPTION_ID = var.subscription_id,
      }
    )
  ]
  depends_on = [
    azurerm_kubernetes_cluster.main,
    azurerm_role_assignment.external_dns
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
    "${file("${path.module}/../helm/cert-manager/values.yaml")}"
  ]

  depends_on = [
    azurerm_kubernetes_cluster.main,
    azurerm_role_assignment.external_dns,
    helm_release.external_dns
  ]
}

resource "kubectl_manifest" "cert-manager-issuer" {
  yaml_body = templatefile(
    "${path.module}/../helm/cert-manager/issuer.yaml", 
    {
      EMAIL = var.email, 
      SUBSCRIPTION_ID = var.subscription_id,
      DNS_ZONE_RESOURCE_GROUP = var.resource_name
      DNS_ZONE_NAME = var.dns_name
      MANAGED_IDENTITY_CLIENT_ID = azurerm_kubernetes_cluster.main.kubelet_identity.0.client_id
    }
  )
  depends_on = [
    helm_release.cert-manager
  ]
}