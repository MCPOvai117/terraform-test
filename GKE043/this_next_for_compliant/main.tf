provider "google" {
  credentials = "C:/Users/DE121623/Documents/Terraform/creds.json"
  project = "pg-xa-n-app-230466"
  region  = "europe-west3"
  zone    = "europe-west3-a"
}

data "google_client_config" "default" {
  provider = google # workaround for https://github.com/hashicorp/terraform-provider-google/issues/14602
}

data "google_container_cluster" "main" {
  name     = "gke00423-public"
  location = "europe-west3-a"
  project  = "pg-xa-n-app-230466"
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.main.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.main.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_pod_security_policy" "restricted" {
  metadata {
    name = "gke00423-restricted"
  }
  spec {
    host_ipc = false

    privileged                 = false
    allow_privilege_escalation = false

    volumes = [
      "configMap",
      "emptyDir",
      "projected",
      "secret",
      "downwardAPI",
      "persistentVolumeClaim",
    ]

    run_as_user {
      rule = "MustRunAsNonRoot"
    }

    se_linux {
      rule = "RunAsAny"
    }

    supplemental_groups {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    fs_group {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    read_only_root_filesystem = true
  }
}

resource "kubernetes_pod_security_policy" "unrestricted" {
  metadata {
    name = "gke00423-unrestricted"
  }
  spec {
    host_ipc = true

    privileged                 = false
    allow_privilege_escalation = false

    volumes = [
      "configMap",
      "emptyDir",
      "projected",
      "secret",
      "downwardAPI",
      "persistentVolumeClaim",
    ]

    run_as_user {
      rule = "MustRunAsNonRoot"
    }

    se_linux {
      rule = "RunAsAny"
    }

    supplemental_groups {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    fs_group {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    read_only_root_filesystem = true
  }
}
