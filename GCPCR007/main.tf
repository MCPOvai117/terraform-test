provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project     = "pg-xa-n-app-230466"
  region      = "europe-west3"
}


resource "google_service_account" "myaccountcompliant" {
  account_id   = "myaccountcompliant"
  display_name = "My Compliant Service Account"
}

# note this requires the terraform to be run regularly
resource "time_rotating" "mykey_rotationcompliant" {
  rotation_days = 30
}

resource "google_service_account_key" "mykeycompliant" {
  service_account_id = google_service_account.myaccountcompliant.name

  keepers = {
    rotation_time = time_rotating.mykey_rotationcompliant.rotation_rfc3339
  }
}

resource "google_service_account" "myaccountnoncompliant" {
  account_id   = "myaccountnoncompliant"
  display_name = "My Non Compliant Service Account"
}

# note this requires the terraform to be run regularly
resource "time_rotating" "mykey_rotationnoncompliant" {
  rotation_days = 180
}

resource "google_service_account_key" "mykeynoncompliant" {
  service_account_id = google_service_account.myaccountnoncompliant.name

  keepers = {
    rotation_time = time_rotating.mykey_rotationnoncompliant.rotation_rfc3339
  }
}