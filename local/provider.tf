provider "kubernetes" {
  config_path = "/root/.kube/config"  # Path to the Kubernetes config inside the Jenkins container
  host                   = "https://${MINIKUBE_IP}:8443"  # Minikube Kubernetes API
  client_certificate     = file("/var/lib/minikube/certs/client.crt")  # Path to the client certificate
  client_key             = file("/var/lib/minikube/certs/client.key")  # Path to the client key
  cluster_ca_certificate = file("/var/lib/minikube/certs/ca.crt")  # Path to the cluster CA certificate
}

provider "helm" {
  kubernetes {
    config_path = "/root/.kube/config"  # Path to the Kubernetes config for Helm as well
  }
}
