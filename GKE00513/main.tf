provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = var.default_gcp_project_id
}

data "google_client_config" "default" {
}

resource "google_project_service" "gke00513_services" {
  for_each           = toset(local.project_services)
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_network" "gke00513_network" {
  name = "gke00513-network"
}

resource "google_service_account" "gke00513_compliant_service_account" {
  account_id   = "gke00513-compliant-sa"
  display_name = "GKE00513 Compliant Service Account"
}


resource "google_container_cluster" "gke00513_compliant_cluster" {
  name               = "gke00513-compliant-cluster"
  location           = var.default_gcp_zone
  network            = google_compute_network.gke00513_network.self_link

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
    service_account = google_service_account.gke00513_compliant_service_account.email
  }
  depends_on = [google_project_service.gke00513_services]
}

resource "google_service_account" "gke00513_non_compliant_service_account" {
  account_id   = "gke00513-non-compliant-sa"
  display_name = "GKE00513 Non Compliant Service Account"
}

resource "google_container_cluster" "gke00513_non_compliant_cluster" {
  name               = "gke00513-non-compliant-cluster"
  location           = var.default_gcp_zone
  network            = google_compute_network.gke00513_network.self_link

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
    service_account = google_service_account.gke00513_non_compliant_service_account.email
  }
  depends_on = [google_project_service.gke00513_services]
}

resource "google_container_registry" "gke00513_registry" {
  project  = var.default_gcp_project_id
}

resource "google_storage_bucket_iam_member" "gke00513_compliant_bucket_member" {
  bucket = google_container_registry.gke00513_registry.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.gke00513_compliant_service_account.email}"
}

resource "google_storage_bucket_iam_member" "gke00513_non_compliant_bucket_member" {
  bucket = google_container_registry.gke00513_registry.id
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.gke00513_non_compliant_service_account.email}"
}
