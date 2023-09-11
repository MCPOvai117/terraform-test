provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project     = "pg-xa-n-app-230466"
  region      = "europe-west3"
}


resource "google_sql_database_instance" "compliant" {
  name = "gcpml011-sql-compliant"
  database_version = "POSTGRES_14"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"

    database_flags {
      name ="log_connections"
      value = "on"
    }
  }
}

resource "google_sql_database_instance" "not-compliant-value-set" {
  name = "gcpml011-sql-not-compliant-value-set"
  database_version = "POSTGRES_14"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"

    database_flags {
      name ="log_connections"
      value = "off"
    }
  }
}

resource "google_sql_database_instance" "not-compliant-value-missing" {
  name = "gcpml011-sql-not-compliant-value-missing"
  database_version = "POSTGRES_14"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database_instance" "not-applicable" {
  name = "gcpml011-sql-not-applicable"
  database_version = "MYSQL_8_0"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
  }
}
