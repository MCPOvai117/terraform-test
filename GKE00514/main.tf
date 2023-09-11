provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = var.default_gcp_project_id
}

resource "google_project_service" "gke00514_services" {
  for_each           = toset(local.project_services)
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_network" "gke00514_network" {
  name = "gke00514-network"
}

resource "google_container_cluster" "gke00514_compliant_cluster" {
  name     = "gke00514-compliant-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00514_network.self_link

  binary_authorization {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00514_services]
}

resource "google_container_cluster" "gke00514_non_compliant_cluster" {
  name     = "gke00514-non-compliant-cluster"
  location = var.default_gcp_zone
  network  = google_compute_network.gke00514_network.self_link

  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"
  }
  depends_on = [google_project_service.gke00514_services]
}

# resource "google_binary_authorization_policy" "gke00514_compliant_policy" {
#  admission_whitelist_patterns {
#    name_pattern = "gcr.io/google_containers/*"
#  }

#  default_admission_rule {
#    evaluation_mode  = "ALWAYS_DENY"
#    enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
#  }

#  depends_on = [google_project_service.gke00514_services]
#}

# Only one policy can exist. Last one will overwrite the existing one

# resource "google_binary_authorization_policy" "gke00514_non_compliant_policy" {

#   default_admission_rule {
#     evaluation_mode  = "ALWAYS_ALLOW"
#     enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
#   }

#   depends_on = [google_project_service.gke00514_services]
# }

# Non compliant binary policy which does not have any whitelist pattern

 resource "google_binary_authorization_policy" "gke00514_non_compliant_policy_2" {

   default_admission_rule {
    evaluation_mode  = "ALWAYS_DENY"
     enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
   }

   depends_on = [google_project_service.gke00514_services]
 }
