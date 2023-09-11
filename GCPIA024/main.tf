provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = var.default_gcp_project_id
  region  = var.default_gcp_region
}

resource "google_project_service" "gcpia024_services" {
  for_each           = toset(local.project_services)
  service            = each.key
  disable_on_destroy = true
}

resource "google_storage_bucket" "gcpia024_bucket" {
  name     = "gcpia024-cloudfunction-content"
  location = "EU"
}

resource "google_storage_bucket_object" "gcpia024_object" {
  name   = "index.zip"
  bucket = google_storage_bucket.gcpia024_bucket.name
  source = "cloudfunction/index.zip"
}

resource "google_cloudfunctions_function" "gcpia024_non_compliant_function" {
  name        = "gcpia023-non-complaint-function"
  description = "GCPIA023 Non-Compliant Function"
  runtime     = "nodejs16"

  available_memory_mb          = 128
  source_archive_bucket        = google_storage_bucket.gcpia024_bucket.name
  source_archive_object        = google_storage_bucket_object.gcpia024_object.name
  ingress_settings             = "ALLOW_ALL"
  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"
  timeout                      = 60
  entry_point                  = "helloGET"

  build_environment_variables = {
    GCPIA023_NON_COMPLIANT_BUILD_VAR = "gcpia023-non-complaint-build-var-value"
  }

  environment_variables = {
    GCPIA023_NON_COMPLIANT_VAR = "gcpia023-non-complaint-var-value"
  }
  depends_on = [google_project_service.gcpia024_services]
}

resource "google_cloudfunctions_function" "gcpia024_compliant_function" {
  name        = "gcpia023-complaint-function"
  description = "GCPIA023-Compliant Function"
  runtime     = "nodejs16"
  region      = "europe-west1"

  available_memory_mb          = 128
  source_archive_bucket        = google_storage_bucket.gcpia024_bucket.name
  source_archive_object        = google_storage_bucket_object.gcpia024_object.name
  ingress_settings             = "ALLOW_ALL"
  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"
  timeout                      = 60
  entry_point                  = "helloGET"

  depends_on = [google_project_service.gcpia024_services]
}
