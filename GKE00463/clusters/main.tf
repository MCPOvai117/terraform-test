provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = "pg-xa-n-app-230466"
  region  = "europe-west3"
}

resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "main" {
  name                            = "gke00463"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

resource "google_compute_subnetwork" "private" {
  name                     = "gke00463"
  ip_cidr_range            = "10.0.0.0/18"
  region                   = "europe-west3"
  network                  = google_compute_network.main.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}

resource "google_container_cluster" "public" {
  name                     = "gke00463-public"
  location                 = "europe-west3-a"
  remove_default_node_pool = false
  initial_node_count       = 1
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "none"
  networking_mode          = "VPC_NATIVE"
 
  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }
}
