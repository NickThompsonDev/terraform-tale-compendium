variable "minikube_ip" {
  type        = string
  description = "The IP address of the Minikube cluster"
}

variable "DATABASE_USER" {
  type        = string
  description = "Database user for the PostgreSQL instance"
}

variable "DATABASE_PASSWORD" {
  type        = string
  description = "Database password for the PostgreSQL instance"
}

variable "DATABASE_NAME" {
  type        = string
  description = "Database name for the PostgreSQL instance"
}

variable "NEXT_PUBLIC_API_URL" {
  type        = string
  description = "Public API URL"
}

variable "NEXT_PUBLIC_WEBAPP_URL" {
  type        = string
  description = "Public Webapp URL"
}

variable "tls_secret_name" {
  type        = string
  description = "TLS secret for HTTPS"
}
