provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = var.default_gcp_project_id
}

provider "google-beta" {
  project = var.default_gcp_project_id
}
provider "kubernetes" {
  host                   = "https://${google_container_cluster.gke_gke00441_non_compliant_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.gke_gke00441_non_compliant_cluster.master_auth.0.cluster_ca_certificate)
}

data "google_client_config" "default" {
}

resource "google_project_service" "gke00441_services" {
  for_each           = toset(local.project_services)
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_network" "gke00441_network" {
  name = "gke00441-network"
}

resource "google_container_cluster" "gke_gke00441_compliant_cluster" {
  name     = "gke00441-compliant-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00441_network.self_link

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00441_services]
}

resource "google_container_cluster" "gke_gke00441_non_compliant_cluster" {
  name               = "gke00441-non-compliant-cluster"
  location           = var.default_gcp_zone
  network            = google_compute_network.gke00441_network.self_link
  enable_legacy_abac = true

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00441_services]
}

