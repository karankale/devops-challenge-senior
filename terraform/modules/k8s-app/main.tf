resource "kubernetes_deployment" "app" {
  metadata {
    name = "simple-time-app"
    labels = {
      app = "simple-time-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "simple-time-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "simple-time-app"
        }
      }

      spec {
        container {
          name  = "simple-time-app"
          image = "public.ecr.aws/bitnami/python:3.10"
          command = ["python", "-m", "http.server", "8000"]
          port {
            container_port = 8000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app_svc" {
  metadata {
    name = "simple-time-app"
  }

  spec {
    selector = {
      app = "simple-time-app"
    }

    port {
      port        = 80
      target_port = 8000
    }

    type = "LoadBalancer"
  }
}