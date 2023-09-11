provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project     = "pg-xa-n-app-230466"
  region      = "europe-west3"
}


resource "google_apikeys_key" "compliant-apikeys" {
  name         = "compliant-apikeys"
  display_name = "Nice name displayed in the UI"

  restrictions {
        # Example of whitelisting Maps Javascript API and Places API only
        api_targets {
            service = "logging.googleapis.com"
        }
        browser_key_restrictions {
            allowed_referrers = [".*"]
        }
  }
}

resource "google_apikeys_key" "noncompliant-keys" {
  name         = "noncompliant-keys"
  display_name = "sample-key"
}