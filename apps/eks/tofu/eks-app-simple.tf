resource "kubernetes_service_account" "test_app_sa" {
  metadata {
    name      = "test-app-sa"
    namespace = "test-app-namespace"
  }
}

resource "kubernetes_service" "insecure" {
  metadata {
    name      = "insecure"
    namespace = "test-app-namespace"
  }

  spec {
    port {
      protocol    = "TCP"
      port        = 8080
      target_port = 8080
    }
    session_affinity = "ClientIP"

    selector = {
      app = "insecure"
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "insecure" {
  metadata {
    name      = "insecure"
    namespace = "test-app-namespace"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "insecure"
      }
    }

    template {
      metadata {
        labels = {
          app = "insecure"
        }
      }

      spec {
        container {
          name  = "original-app-container"
          image = "quincycheng/original-simple-golang-app:v1.0"

          port {
            container_port = 3000
          }

          env {
            name  = "THE_SECRET"
            value = "thisIsNotSecure"
          }
        }
        service_account_name = "test-app-sa"
      }
    }
  }
}