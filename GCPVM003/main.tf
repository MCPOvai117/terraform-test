provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = var.default_gcp_project_id
  region  = var.default_gcp_region
}

resource "google_project_service" "gcpvm003_services" {
  for_each           = toset(local.project_services)
  service            = each.key
  disable_on_destroy = true
}

resource "google_storage_bucket" "gcpvm003_bucket" {
  name     = "gcpvm003-appengine-content"
  location = "EU"
}

resource "google_storage_bucket_object" "gcpvm003_object" {
  name   = "app.js"
  bucket = google_storage_bucket.gcpvm003_bucket.name
  source = "./appengine/app.js"
}

# Created once, can't be recreated


# resource "google_app_engine_application" "gcpvm003_app" {
#   project     = var.default_gcp_project_id
#   location_id = var.default_gcp_region
#   depends_on = [ google_project_service.gcpvm003_services ]
# }

# resource "google_app_engine_standard_app_version" "gcpvm003_default_app_v1" {

#   version_id = "v1"
#   service    = "default"
#   runtime    = "nodejs16"

#   entrypoint {
#     shell = "node ./app.js"
#   }

#   deployment {
#     files {
#       name       = google_storage_bucket_object.gcpvm003_object.name
#       source_url = "https://storage.googleapis.com/${google_storage_bucket.gcpvm003_bucket.name}/${google_storage_bucket_object.gcpvm003_object.name}"
#     }
#   }

#   env_variables = {
#     port = "8080"
#   }

#   noop_on_destroy           = true
#   delete_service_on_destroy = false
#   depends_on                = [google_app_engine_application.gcpvm003_app, google_project_service.gcpvm003_services]
# }



resource "google_app_engine_standard_app_version" "gcpvm003_compliant_app_v1" {

  version_id = "v1"
  service    = "gcpvm003-compliant-app"
  runtime    = "nodejs16"

  entrypoint {
    shell = "node ./app.js"
  }

  handlers {
    url_regex                   = ".*"
    security_level              = "SECURE_ALWAYS"
    redirect_http_response_code = "REDIRECT_HTTP_RESPONSE_CODE_301"
    script {
      script_path = "auto"
    }
  }

  deployment {
    files {
      name       = google_storage_bucket_object.gcpvm003_object.name
      source_url = "https://storage.googleapis.com/${google_storage_bucket.gcpvm003_bucket.name}/${google_storage_bucket_object.gcpvm003_object.name}"
    }
  }

  env_variables = {
    port = "8080"
  }

  noop_on_destroy           = false
  delete_service_on_destroy = true
  depends_on                = [google_project_service.gcpvm003_services]
}

resource "google_app_engine_standard_app_version" "gcpvm003_non_compliant_app_v1" {

  version_id = "v1"
  service    = "gcpvm003-non-compliant-app"
  runtime    = "nodejs16"

  entrypoint {
    shell = "node ./app.js"
  }

  deployment {
    files {
      name       = google_storage_bucket_object.gcpvm003_object.name
      source_url = "https://storage.googleapis.com/${google_storage_bucket.gcpvm003_bucket.name}/${google_storage_bucket_object.gcpvm003_object.name}"
    }
  }

  env_variables = {
    port = "8080"
  }

  noop_on_destroy           = false
  delete_service_on_destroy = true
  depends_on                = [ google_project_service.gcpvm003_services]
}
