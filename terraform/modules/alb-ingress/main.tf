provider "kubernetes" {
  host = var.cluster_endpoint
  token = var.cluster_token
  cluster_ca_certificate = base64decode(var.cluster_ca)
}

resource "kubernetes_ingress_v1" "alb" {
  metadata {
    name = "simple-time-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }
  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = var.service_name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
