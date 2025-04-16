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
          name    = "simple-time-app"
          image   = "079892728706.dkr.ecr.us-east-1.amazonaws.com/simple-time-service:8372415580e21c9c021de99248f528071c785b09"
          command = ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
          port {
            container_port = 5000
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
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}