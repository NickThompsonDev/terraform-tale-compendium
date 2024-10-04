# Define the namespace for the services
resource "kubernetes_namespace" "local" {
  metadata {
    name = "local"
  }
}

# API Deployment
resource "kubernetes_deployment" "api" {
  metadata {
    name = "api-deployment"
    namespace = kubernetes_namespace.local.metadata[0].name
    labels = {
      app = "api"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "api"
      }
    }
    template {
      metadata {
        labels = {
          app = "api"
        }
      }
      spec {
        container {
          image = "api-tale-compendium:latest"
          name  = "api"
          port {
            container_port = 5000
          }
          env {
            name  = "DATABASE_URL"
            value = "postgres://user:password@postgres-service.local:5432/mydb"
          }
          env {
            name  = "NEXT_PUBLIC_API_URL"
            value = "http://${var.minikube_ip}:5000/api"
          }
          env {
            name  = "NEXT_PUBLIC_WEBAPP_URL"
            value = "http://${var.minikube_ip}:3000"
          }
        }
      }
    }
  }
}

# API Service
resource "kubernetes_service" "api-service" {
  metadata {
    name = "api-service"
    namespace = kubernetes_namespace.local.metadata[0].name
  }
  spec {
    selector = {
      app = "api"
    }
    port {
      port        = 5000
      target_port = 5000
    }
    type = "NodePort"
  }
}

# Webapp Deployment
resource "kubernetes_deployment" "webapp" {
  metadata {
    name = "webapp-deployment"
    namespace = kubernetes_namespace.local.metadata[0].name
    labels = {
      app = "webapp"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "webapp"
      }
    }
    template {
      metadata {
        labels = {
          app = "webapp"
        }
      }
      spec {
        container {
          image = "webapp-tale-compendium:latest"
          name  = "webapp"
          port {
            container_port = 3000
          }
          env {
            name  = "NEXT_PUBLIC_API_URL"
            value = "http://${var.minikube_ip}:5000/api"
          }
          env {
            name  = "NEXT_PUBLIC_WEBAPP_URL"
            value = "http://${var.minikube_ip}:3000"
          }
        }
      }
    }
  }
}

# Webapp Service
resource "kubernetes_service" "webapp-service" {
  metadata {
    name = "webapp-service"
    namespace = kubernetes_namespace.local.metadata[0].name
  }
  spec {
    selector = {
      app = "webapp"
    }
    port {
      port        = 3000
      target_port = 3000
    }
    type = "NodePort"
  }
}

# PostgreSQL Deployment
resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres-deployment"
    namespace = kubernetes_namespace.local.metadata[0].name
    labels = {
      app = "postgres"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgres"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }
      spec {
        container {
          image = "postgres:13"
          name  = "postgres"
          port {
            container_port = 5432
          }
          env {
            name  = "POSTGRES_USER"
            value = "user"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "password"
          }
          env {
            name  = "POSTGRES_DB"
            value = "mydb"
          }
        }
      }
    }
  }
}

# PostgreSQL Service
resource "kubernetes_service" "postgres-service" {
  metadata {
    name = "postgres-service"
    namespace = kubernetes_namespace.local.metadata[0].name
  }
  spec {
    selector = {
      app = "postgres"
    }
    port {
      port        = 5432
      target_port = 5432
    }
    type = "ClusterIP"
  }
}

# Ingress for API and Webapp with HTTPS (TLS)
resource "kubernetes_ingress" "app-ingress" {
  metadata {
    name = "app-ingress"
    namespace = kubernetes_namespace.local.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "nginx.ingress.kubernetes.io/ssl-redirect"   = "true"
    }
  }
  spec {
    tls {
      secret_name = "tls-secret"  # Reference to your TLS secret
    }
    rule {
      host = "talecompendium.localhost"  # Your local domain
      http {
        path {
          path = "/api"
          backend {
            service_name = kubernetes_service.api-service.metadata[0].name
            service_port = 5000
          }
        }
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.webapp-service.metadata[0].name
            service_port = 3000
          }
        }
      }
    }
  }
}
