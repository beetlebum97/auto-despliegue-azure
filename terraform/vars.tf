# vars.tf
variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
  sensitive   = true # Marca la variable como sensible
}

variable "tenant_id" {
  description = "ID del tenant de Azure AD"
  type        = string
  sensitive   = true # Marca la variable como sensible
}
