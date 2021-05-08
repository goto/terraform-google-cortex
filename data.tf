data "kubernetes_service" "cortex" {

  depends_on = [
    helm_release.cortex
  ]
  metadata {
    name      = var.load_balancer_ingress_name
    namespace = var.load_balancer_ingress_namespace
  }
}
