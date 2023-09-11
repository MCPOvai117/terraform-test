resource "kubectl_manifest" "gke00568_compliant_k8s_ns" {
  yaml_body  = file("compliant_k8s_objects/namespace.yaml")
  depends_on = [google_container_cluster.gke00568_compliant_cluster]
}

resource "kubectl_manifest" "gke00568_compliant_k8s_deployment" {
  yaml_body  = file("compliant_k8s_objects/deployment.yaml")
  depends_on = [google_container_cluster.gke00568_compliant_cluster, kubectl_manifest.gke00568_compliant_k8s_ns]
}
resource "kubectl_manifest" "gke00568_compliant_k8s_service" {
  yaml_body  = file("compliant_k8s_objects/service.yaml")
  depends_on = [google_container_cluster.gke00568_compliant_cluster, kubectl_manifest.gke00568_compliant_k8s_ns]
}

resource "kubectl_manifest" "gke00568_compliant_k8s_managed_certificate" {
  yaml_body  = file("compliant_k8s_objects/managed_certificate.yaml")
  depends_on = [google_container_cluster.gke00568_compliant_cluster, kubectl_manifest.gke00568_compliant_k8s_ns]
}

resource "kubectl_manifest" "gke00568_compliant_k8s_ingress" {
  yaml_body  = file("compliant_k8s_objects/ingress.yaml")
  depends_on = [google_container_cluster.gke00568_compliant_cluster, google_compute_global_address.gke00568_global_static_ip_address, kubectl_manifest.gke00568_compliant_k8s_ns]
}

resource "kubectl_manifest" "gke00568_non_compliant_k8s_ns" {
  provider   = kubectl.non-compliant
  yaml_body  = file("non_compliant_k8s_objects/namespace.yaml")
  depends_on = [google_container_cluster.gke00568_non_compliant_cluster]
}

resource "kubectl_manifest" "gke00568_non_compliant_k8s_deployment" {
  provider   = kubectl.non-compliant
  yaml_body  = file("non_compliant_k8s_objects/deployment.yaml")
  depends_on = [google_container_cluster.gke00568_non_compliant_cluster, kubectl_manifest.gke00568_non_compliant_k8s_ns]
}

resource "kubectl_manifest" "gke00568_non_compliant_k8s_service_1" {
  provider   = kubectl.non-compliant
  yaml_body  = file("non_compliant_k8s_objects/service-1.yaml")
  depends_on = [google_container_cluster.gke00568_non_compliant_cluster, kubectl_manifest.gke00568_non_compliant_k8s_ns]
}

resource "kubectl_manifest" "gke00568_non_compliant_k8s_service_2" {
  provider   = kubectl.non-compliant
  yaml_body  = file("non_compliant_k8s_objects/service-2.yaml")
  depends_on = [google_container_cluster.gke00568_non_compliant_cluster, kubectl_manifest.gke00568_non_compliant_k8s_ns]
}

resource "kubectl_manifest" "gke00568_non_compliant_k8s_ingress_1" {
  provider   = kubectl.non-compliant
  yaml_body  = file("non_compliant_k8s_objects/ingress-1.yaml")
  depends_on = [google_container_cluster.gke00568_non_compliant_cluster, kubectl_manifest.gke00568_non_compliant_k8s_ns]
}

resource "kubectl_manifest" "gke00568_non_compliant_k8s_ingress_2" {
  provider   = kubectl.non-compliant
  yaml_body  = file("non_compliant_k8s_objects/ingress-2.yaml")
  depends_on = [google_container_cluster.gke00568_non_compliant_cluster, kubectl_manifest.gke00568_non_compliant_k8s_ns]
}