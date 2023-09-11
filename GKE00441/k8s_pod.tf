resource "kubernetes_secret" "gke00441_k8s_secret" {
  metadata {
    name = "gke00441-secret"
  }
  data = {
    environment = "test"
  }

  type = "Opaque"
}
resource "kubernetes_pod" "gke00441_k8s_non_compliant_pod" {
  metadata {
    name = "gke00441-non-compliant-pod"
  }

  spec {
    container {
      image = "nginx:1.21.6"
      name  = "gke00441-non-compliant-container"
      env {
        name  = "environment"
        value_from {
          secret_key_ref {
            key  = "environment"
            name = "gke00441-secret"
          }
        }
      }

      port {
        container_port = 80
      }

      liveness_probe {
        http_get {
          path = "/"
          port = 80
        }

        initial_delay_seconds = 3
        period_seconds        = 3
      }
    }

    dns_config {
      nameservers = ["1.1.1.1", "8.8.8.8", "9.9.9.9"]
      searches    = ["example.com"]

      option {
        name  = "ndots"
        value = 1
      }

      option {
        name = "use-vc"
      }
    }

    dns_policy = "None"
  }
  depends_on = [google_container_cluster.gke_gke00441_non_compliant_cluster, kubernetes_secret.gke00441_k8s_secret]
}
