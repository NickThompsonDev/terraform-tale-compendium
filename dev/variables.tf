# Project and region variables
variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "us-east1"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "tale-compendium-cluster"
}

variable "node_count" {
  description = "Number of nodes in the GKE cluster"
  type        = number
  default     = 3
}

variable "node_machine_type" {
  description = "The machine type to use for the GKE cluster"
  type        = string
  default     = "e2-medium"
}

variable "docker_image_tag" {
  description = "Tag for the Docker image"
  type        = string
  default     = "latest"
}

# Database variables
variable "database_name" {
  description = "The name of the database"
  type        = string
  default     = "mydatabase"
}

variable "database_user" {
  description = "The database username"
  type        = string
  default     = "user"
  sensitive   = true
}

variable "database_password" {
  description = "The database password"
  type        = string
  sensitive   = true
}

# API keys and secrets
variable "stripe_publishable_key" {
  description = "Stripe publishable key"
  type        = string
  sensitive   = true
}

variable "stripe_secret_key" {
  description = "Stripe secret key"
  type        = string
  sensitive   = true
}

variable "clerk_publishable_key" {
  description = "Clerk publishable key"
  type        = string
  sensitive   = true
}

variable "clerk_secret_key" {
  description = "Clerk secret key"
  type        = string
  sensitive   = true
}

variable "openai_api_key" {
  description = "OpenAI API key"
  type        = string
  sensitive   = true
}

variable "service_account_email" {
  description = "The email of the GCP service account"
  type        = string
  default     = "github-actions-deployer@nodal-clock-433208-b4.iam.gserviceaccount.com"
}

# Clerk URLs
variable "clerk_sign_in_url" {
  description = "Clerk sign-in URL"
  type        = string
  sensitive   = true
}

variable "clerk_sign_up_url" {
  description = "Clerk sign-up URL"
  type        = string
  sensitive   = true
}

variable "clerk_webhook_secret" {
  description = "Clerk webhook secret"
  type        = string
  sensitive   = true
}

# Webapp and API URLs
variable "next_public_webapp_url" {
  description = "Public URL for the webapp, updated after deployment"
  type        = string
  sensitive   = true
}

variable "next_public_api_url" {
  description = "Internal API URL for backend services communication"
  type        = string
}

# Database host
variable "database_host" {
  description = "Database host URL"
  type        = string
  sensitive   = true
}

variable "gcs_bucket_name" {
  description = "The name of the Google Cloud Storage bucket"
  type        = string
  default     = "talecompendium-images"
}

variable "google_credentials" {
  description = "The contents of the GCP service account JSON file"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "The environment to deploy to (dev or main)"
  type        = string
  default     = "dev"
}
