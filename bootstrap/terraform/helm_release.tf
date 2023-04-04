data "kubectl_file_documents" "ingress_manifest" {
  content = file("${path.module}/../helm/ingress/values.yaml")
}

resource "kubectl_manifest" "ingress_namespace" {
  yaml_body = file("${path.module}/../helm/ingress/namespace.yaml")

  depends_on = [
    azurerm_kubernetes_cluster.main
  ]
}

resource "kubectl_manifest" "ingress_controller" {
  count     = length(data.kubectl_file_documents.ingress_manifest.documents)
  yaml_body = element(data.kubectl_file_documents.ingress_manifest.documents, count.index)

  server_side_apply = true

  depends_on = [
    kubectl_manifest.ingress_namespace
  ]
}

resource "helm_release" "argocd_operator" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.25.0"
  namespace        = "argocd"
  create_namespace = true

  values = [
    "${file("${path.module}/../helm/argocd/values.yaml")}"
  ]

  depends_on = [
    kubectl_manifest.cert_manager_issuer
  ]
}


resource "kubectl_manifest" "argocd_sync_app" {
  yaml_body = file("${path.module}/../helm/argocd/applicationset.yaml")

  depends_on = [
    helm_release.argocd_operator
  ]
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  version          = "6.14.3"
  namespace        = "external-dns"
  create_namespace = true

  values = [
    templatefile(
      "${path.module}/../helm/externaldns/values.yaml",
      {
        RESOURCE_GROUP  = var.resource_group_name,
        TENANT_ID       = var.tenant_id,
        SUBSCRIPTION_ID = var.subscription_id,
        DOMAIN_NAME     = var.dns_name
      }
    )
  ]
  depends_on = [
    azurerm_role_assignment.external_dns
  ]
}


resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "1.11.0"
  namespace        = "cert-manager"
  create_namespace = true

  values = [
    "${file("${path.module}/../helm/cert-manager/values.yaml")}"
  ]

  depends_on = [
    helm_release.external_dns
  ]
}

resource "kubectl_manifest" "cert_manager_issuer" {
  yaml_body = templatefile(
    "${path.module}/../helm/cert-manager/issuer.yaml",
    {
      EMAIL                      = var.email,
      SUBSCRIPTION_ID            = var.subscription_id,
      DNS_ZONE_RESOURCE_GROUP    = var.resource_group_name
      DNS_ZONE_NAME              = var.dns_name
      MANAGED_IDENTITY_CLIENT_ID = azurerm_kubernetes_cluster.main.kubelet_identity.0.client_id
    }
  )
  depends_on = [
    helm_release.cert_manager
  ]
}

resource "kubectl_manifest" "db_secrets" {
  yaml_body = templatefile(
    "${path.module}/../helm/secrets/db-secrets.yaml",
    {
      DB_NAME = base64encode("${var.db_name}")
      DB_PASSWORD = base64encode("${var.db_password}")
      DB_USER = base64encode("${var.db_user}")
      DB_HOST = base64encode("${var.db_host}")
    }
  )
  depends_on = [
    azurerm_kubernetes_cluster.main
  ]
}
