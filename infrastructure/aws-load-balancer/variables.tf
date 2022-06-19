variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "cluster_endpoint" {
  type        = string
  description = "Endpoint for your Kubernetes API server"
}

variable "cluster_certificate_authority_data" {
  type        = string
  description = "Base64 encoded certificate data required to communicate with the cluster"
}

variable "oidc_provider_arn" {
  type        = string
  description = "The ARN of the OIDC Provider"
}

variable "oidc_provider" {
  type        = string
  description = "The OpenID Connect identity provider"
}
