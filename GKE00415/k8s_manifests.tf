resource "kubectl_manifest" "gke00415_compliant_k8s_default_sa_default" {
  yaml_body  = file("compliant_k8s_objects/default_sa_default.yaml")
  depends_on = [google_container_cluster.gke00415_compliant_cluster]
}

resource "kubectl_manifest" "gke00415_compliant_k8s_default_sa_kube_node_lease" {
  yaml_body  = file("compliant_k8s_objects/default_sa_kube-node-lease.yaml")
  depends_on = [google_container_cluster.gke00415_compliant_cluster]
}

resource "kubectl_manifest" "gke00415_compliant_k8s_default_sa_kube_system" {
  yaml_body  = file("compliant_k8s_objects/default_sa_kube-system.yaml")
  depends_on = [google_container_cluster.gke00415_compliant_cluster]
}

resource "kubectl_manifest" "gke00415_compliant_k8s_default_sa_kube_public" {
  yaml_body  = file("compliant_k8s_objects/default_sa_kube-public.yaml")
  depends_on = [google_container_cluster.gke00415_compliant_cluster]
}

resource "kubectl_manifest" "gke00415_non_compliant_k8s_ns" {
  provider   = kubectl.non-compliant
  yaml_body  = file("non_compliant_k8s_objects/namespace-1.yaml")
  depends_on = [google_container_cluster.gke00415_non_compliant_cluster]
}
resource "kubectl_manifest" "gke00415_non_compliant_k8s_sa" {
  provider   = kubectl.non-compliant
  yaml_body  = file("non_compliant_k8s_objects/default_sa.yaml")
  depends_on = [google_container_cluster.gke00415_non_compliant_cluster, kubectl_manifest.gke00415_non_compliant_k8s_ns]
}
resource "kubectl_manifest" "gke00415_non_compliant_k8s_rb" {
  provider   = kubectl.non-compliant
  yaml_body  = file("non_compliant_k8s_objects/rolebinding.yaml")
  depends_on = [google_container_cluster.gke00415_non_compliant_cluster, kubectl_manifest.gke00415_non_compliant_k8s_ns]
}

resource "kubectl_manifest" "gke00415_non_compliant_k8s_crb" {
  provider   = kubectl.non-compliant
  yaml_body  = file("non_compliant_k8s_objects/cluster_role_binding.yaml")
  depends_on = [google_container_cluster.gke00415_non_compliant_cluster, kubectl_manifest.gke00415_non_compliant_k8s_ns]
}
resource "kubectl_manifest" "gke00415_non_compliant_k8s_ns_2" {
  provider   = kubectl.non-compliant
  yaml_body  = file("non_compliant_k8s_objects/namespace-2.yaml")
  depends_on = [google_container_cluster.gke00415_non_compliant_cluster]
}
