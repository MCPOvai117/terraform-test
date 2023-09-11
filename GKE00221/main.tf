provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = var.default_gcp_project_id
}

resource "google_project_service" "gke00221_services" {
  for_each           = toset(local.project_services)
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_network" "gke00221_network" {
  name = "gke00221-network"
}

resource "google_container_cluster" "gke00221_compliant_cluster" {
  name     = "gke00221-compliant-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00221_network.self_link

  initial_node_count = 1

  logging_config {
    enable_components = [
      "SYSTEM_COMPONENTS",
      "APISERVER",
    ]
  }

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00221_services]
}

resource "google_container_cluster" "gke00221_non_compliant_cluster" {
  name     = "gke00221-non-compliant-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00221_network.self_link

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00221_services]
}

