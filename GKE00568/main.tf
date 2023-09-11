provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = var.default_gcp_project_id
}
provider "google-beta" {
  project = var.default_gcp_project_id
}
provider "kubectl" {
  host                   = "https://${google_container_cluster.gke00568_compliant_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.gke00568_compliant_cluster.master_auth.0.cluster_ca_certificate)
  load_config_file       = false
}
provider "kubectl" {
  alias                  = "non-compliant"
  host                   = "https://${google_container_cluster.gke00568_non_compliant_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.gke00568_non_compliant_cluster.master_auth.0.cluster_ca_certificate)
  load_config_file       = false
}



data "google_client_config" "default" {
}

resource "google_project_service" "gke00568_services" {
  for_each           = toset(local.project_services)
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_network" "gke00568_network" {
  name = "gke00568-network"
}

resource "google_container_cluster" "gke00568_compliant_cluster" {
  name     = "gke00568-compliant-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00568_network.self_link

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00568_services]
}

resource "google_compute_global_address" "gke00568_global_static_ip_address" {
  name = "gke00568-global-static-ip"
}

resource "google_container_cluster" "gke00568_non_compliant_cluster" {
  name     = "gke00568-non-compliant-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00568_network.self_link

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00568_services]
}

resource "google_container_cluster" "gke00568_non_applicable_cluster" {
  name     = "gke00568-non-applicable-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00568_network.self_link

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00568_services]
}

