provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = var.default_gcp_project_id
}
provider "google-beta" {
  project = var.default_gcp_project_id
}

provider "kubectl" {
  host                   = "https://${google_container_cluster.gke00428_compliant_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.gke00428_compliant_cluster.master_auth.0.cluster_ca_certificate)
  load_config_file       = false
}

data "google_client_config" "default" {
}

resource "google_project_service" "gke00428_services" {
  for_each           = toset(local.project_services)
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_network" "gke00428_network" {
  name = "gke00428-network"
}



data "google_container_engine_versions" "gke00428_k8s_version" {
  provider       = google
  location       = "europe-west3-a"
  version_prefix = "1.24." # pod security policies were removed in kubernetes version 1.25
}

data "google_container_engine_versions" "gke00428_k8s_na_version" {
  provider       = google
  location       = "europe-west3-a"
  version_prefix = "1.25." # pod security policies were removed in kubernetes version 1.25
}


resource "google_container_cluster" "gke00428_compliant_cluster" {
  name     = "gke00428-compliant-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00428_network.self_link

  min_master_version = data.google_container_engine_versions.gke00428_k8s_version.latest_master_version
  node_version       = data.google_container_engine_versions.gke00428_k8s_version.latest_node_version

  monitoring_service = "none"

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00428_services]
}

resource "google_container_cluster" "gke00428_non_compliant_cluster" {
  name     = "gke00428-non-compliant-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00428_network.self_link

  min_master_version = data.google_container_engine_versions.gke00428_k8s_version.latest_master_version
  node_version       = data.google_container_engine_versions.gke00428_k8s_version.latest_node_version

  monitoring_service = "none"

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00428_services]
}

resource "google_container_cluster" "gke00428_non_applicable_cluster" {
  name     = "gke00428-non-applicable-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00428_network.self_link

  min_master_version = data.google_container_engine_versions.gke00428_k8s_na_version.latest_master_version
  node_version       = data.google_container_engine_versions.gke00428_k8s_na_version.latest_node_version

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00428_services]
}
