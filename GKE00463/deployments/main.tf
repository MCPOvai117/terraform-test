provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = "pg-xa-n-app-230466"
  region = "europe-west3"
  zone = "europe-west3-a"
}

data "google_client_config" "default" {
  provider = google   # workaround for https://github.com/hashicorp/terraform-provider-google/issues/14602
}

data "google_container_cluster" "main" {
  name     = "gke00463-public"
  location = "europe-west3-a"
  project = "pg-xa-n-app-230466"
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.main.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.main.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_deployment" "no_contexts" {
  metadata {
    name = "gke00463-no-contexts"
    labels = {
      scenario = "no_contexts"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        scenario = "no_contexts"
      }
    }

    template {
      metadata {
        labels = {
          scenario = "no_contexts"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "main"

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
  }
}
