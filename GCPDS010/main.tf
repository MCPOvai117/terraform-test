provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project     = "pg-xa-n-app-230466"
  region      = "europe-west3"
}


resource "google_sql_database_instance" "compliant-gcpds010" {
  name             = "compliant-gcpds010"
  database_version = "MYSQL_8_0"
  region           = "europe-west3"
  deletion_protection = false

  settings {
         tier = "db-f1-micro"
         database_flags {
            name  = "local_infile"
            value = "off"
          }
  }
}

resource "google_sql_database_instance" "not-compliant-gcpds010" {
  name             = "not-compliant-gcpds010"
  database_version = "MYSQL_8_0"
  region           = "europe-west3"
  deletion_protection = false

  settings {
         tier = "db-f1-micro"
         database_flags {
            name  = "local_infile"
            value = "on"
          }
  }
}