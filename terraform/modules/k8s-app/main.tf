provider "kubernetes" {
  host = var.cluster_endpoint
  token = var.cluster_token
  cluster_ca_certificate = base64decode(var.cluster_ca)
}

resource "kubernetes_deployment" "app" {
  metadata {
    name = "simple-time-service"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "simple-time-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "simple-time-service"
        }
      }
      spec {
        container {
          name  = "app"
          image = var.container_image
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name = "simple-time-service"
  }
  spec {
    selector = {
      app = "simple-time-service"
    }
    port {
      port        = 80
      target_port = 5000
    }
    type = "NodePort"
  }
}
