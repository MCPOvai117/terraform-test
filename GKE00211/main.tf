provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = var.default_gcp_project_id
}

resource "google_project_service" "gke00211_services" {
  for_each           = toset(local.project_services)
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_network" "gke00211_network" {
  name = "gke00211-network"
}

resource "google_container_cluster" "gke00211_compliant_cluster" {
  name     = "gke00211-compliant-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00211_network.self_link

  initial_node_count = 1

  master_auth {
  client_certificate_config {
    issue_client_certificate = false
  }
}
  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00211_services]
}

resource "google_container_cluster" "gke00211_non_compliant_cluster" {
  name     = "gke00211-non-compliant-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00211_network.self_link

 master_auth {
  client_certificate_config {
    issue_client_certificate = true
  }
}
 
  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00211_services]
}

