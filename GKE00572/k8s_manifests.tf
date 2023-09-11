resource "kubectl_manifest" "gke00572_compliant_k8s_ns" {
  yaml_body  = file("compliant_k8s_objects/namespace.yaml")
  depends_on = [google_container_cluster.gke00572_compliant_cluster]
}

resource "kubectl_manifest" "gke00572_compliant_k8s_configmap" {
  yaml_body  = file("compliant_k8s_objects/configmap.yaml")
  depends_on = [google_container_cluster.gke00572_compliant_cluster, kubectl_manifest.gke00572_compliant_k8s_ns]
}
resource "kubectl_manifest" "gke00572_compliant_k8s_daemonset_pod" {
  yaml_body  = file("compliant_k8s_objects/daemonset.yaml")
  depends_on = [google_container_cluster.gke00572_compliant_cluster, kubectl_manifest.gke00572_compliant_k8s_ns]
}
