resource "k8s_apps_v1_deployment" "cert_manager" {
  metadata {
    labels = {
      "app"                          = "cert-manager"
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "cert-manager"
      "helm.sh/chart"                = "cert-manager-v0.14.0"
    }
    name      = "cert-manager"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance"  = "cert-manager"
        "app.kubernetes.io/name"      = "cert-manager"
      }
    }
    template {
      metadata {
        annotations = {
          "prometheus.io/path"   = "/metrics"
          "prometheus.io/port"   = "9402"
          "prometheus.io/scrape" = "true"
        }
        labels = {
          "app"                          = "cert-manager"
          "app.kubernetes.io/component"  = "controller"
          "app.kubernetes.io/instance"   = "cert-manager"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "cert-manager"
          "helm.sh/chart"                = "cert-manager-v0.14.0"
        }
      }
      spec {

        containers {
          args = [
            "--v=2",
            "--cluster-resource-namespace=$(POD_NAMESPACE)",
            "--leader-election-namespace=kube-system",
            "--webhook-namespace=$(POD_NAMESPACE)",
            "--webhook-ca-secret=cert-manager-webhook-ca",
            "--webhook-serving-secret=cert-manager-webhook-tls",
            "--webhook-dns-names=cert-manager-webhook,cert-manager-webhook.cert-manager,cert-manager-webhook.cert-manager.svc",
          ]

          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image             = "quay.io/jetstack/cert-manager-controller:v0.14.0"
          image_pull_policy = "IfNotPresent"
          name              = "cert-manager"

          ports {
            container_port = 9402
            protocol       = "TCP"
          }
          resources {
          }
        }
        service_account_name = "cert-manager"
      }
    }
  }
}