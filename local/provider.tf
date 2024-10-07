provider "kubernetes" {
  config_path = "/root/.kube/config"  # This should point to the config inside Jenkins container
  client_certificate     = file("/var/lib/minikube/certs/client.crt")
  client_key             = file("/var/lib/minikube/certs/client.key")
  cluster_ca_certificate = file("/var/lib/minikube/certs/ca.crt")
}

provider "helm" {
  kubernetes {
    config_path = "/root/.kube/config"  # Path inside Jenkins container
  }
}
