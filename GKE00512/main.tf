provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = var.default_gcp_project_id
}

data "google_client_config" "default" {
}

resource "google_project_service" "gke00512_services" {
  for_each           = toset(local.project_services)
  service            = each.key
  disable_on_destroy = false
}

resource "google_service_account" "gke00512_compliant_service_account" {
  account_id   = "gke00512-compliant-sa"
  display_name = "GKE00512 Compliant Service Account"
}

resource "google_service_account" "gke00512_non_compliant_service_account" {
  account_id   = "gke00512-non-compliant-sa"
  display_name = "GKE00512 Non Compliant Service Account"
}

resource "google_container_registry" "gke00512_registry" {
  project  = var.default_gcp_project_id
}

resource "google_storage_bucket_iam_member" "gke00512_compliant_bucket_member" {
  bucket = google_container_registry.gke00512_registry.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.gke00512_compliant_service_account.email}"
}

resource "google_storage_bucket_iam_member" "gke00512_non_compliant_bucket_member" {
  bucket = google_container_registry.gke00512_registry.id
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.gke00512_non_compliant_service_account.email}"
}
