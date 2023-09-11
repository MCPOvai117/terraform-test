provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = var.default_gcp_project_id
}

resource "google_project_service" "gke00313_services" {
  for_each           = toset(local.project_services)
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_network" "gke00313_network" {
  name = "gke00313-network"
}


resource "google_container_cluster" "gke00313_non_compliant_cluster" {
  name     = "gke00313-non-compliant-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00313_network.self_link

  initial_node_count = 3

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00313_services]
}


