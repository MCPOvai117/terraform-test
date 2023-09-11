provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project     = "pg-xa-n-app-230466"
  region      = "europe-west3"
}


resource "google_project_iam_binding" "gcpia006user"{
project ="pg-xa-n-app-230466"
role = "roles/iam.serviceAccountUser"
members = ["user:wolf.florian@gcp.pwc.com",]
}

resource "google_project_iam_binding" "gcpia006tokencreator"{
project ="pg-xa-n-app-230466"
role = "roles/iam.serviceAccountTokenCreator"
members = ["user:wolf.florian@gcp.pwc.com",]
}
///
///
///
#resource "google_project_iam_member" "project" {
#project ="pg-xa-n-app-230466"
#role = "roles/iam.serviceAccountTokenCreator"
#member = "user:wolf.florian@gcp.pwc.com"
#}