provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project     = "pg-xa-n-app-230466"
  region      = "europe-west3"
}


resource "google_sql_database_instance" "compliant-gcppostgreswithoutml011" {
  name             = "compliant-gcppostgreswithoutml011"
  database_version = "POSTGRES_14"
  region           = "europe-west3"
  deletion_protection = false

  settings {
         tier = "db-f1-micro"
         database_flags {
            name  = "log_error_verbosity"
            value = "default"
          }
           database_flags {
            name  = "log_disconnections"
            value = "on"
          }
          database_flags {
            name  = "log_statement"
            value = "ddl"
          }
          database_flags {
            name  = "log_min_messages"
            value = "warning"
          }
          database_flags {
            name  = "log_min_error_statement"
            value = "error"
          }
          database_flags {
            name  = "log_min_duration_statement"
            value = "-1"
          }
          database_flags {
            name  = "cloudsql.enable_pgaudit"
            value = "on"
          }
  }
}

resource "google_sql_database_instance" "not-compliant-gcppostgreswithoutml011" {
  name             = "not-compliant-gcppostgreswithoutml011"
  database_version = "POSTGRES_14"
  region           = "europe-west3"
  deletion_protection = false

  settings {
         tier = "db-f1-micro"
         database_flags {
            name  = "log_error_verbosity"
            value = "terse"
          }
           database_flags {
            name  = "log_disconnections"
            value = "off"
          }
          database_flags {
            name  = "log_statement"
            value = "none"
          }
          database_flags {
            name  = "log_min_messages"
            value = "notice"
          }
          database_flags {
            name  = "log_min_error_statement"
            value = "notice"
          }
          database_flags {
            name  = "log_min_duration_statement"
            value = "1000"
          }
          database_flags {
            name  = "cloudsql.enable_pgaudit"
            value = "off"
          }
  }
}