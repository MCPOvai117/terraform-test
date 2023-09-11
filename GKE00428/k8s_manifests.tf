resource "kubectl_manifest" "gke00428_compliant_psp"{
    yaml_body = file("psp.yaml")
    depends_on = [ google_container_cluster.gke00428_compliant_cluster]
}