resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role_binding" "cert_manager_controller_certificates" {
  metadata {
    labels = {
      "app"                          = "cert-manager"
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "cert-manager"
      "helm.sh/chart"                = "cert-manager-v0.14.0"
    }
    name = "cert-manager-controller-certificates"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cert-manager-controller-certificates"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "cert-manager"
    namespace = var.namespace
  }
}