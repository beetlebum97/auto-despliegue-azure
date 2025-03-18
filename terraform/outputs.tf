# outputs.tf
output "subscription_id" {
  description = "ID de la suscripción de Azure"
  value       = var.subscription_id
  sensitive   = true # Marca el output como sensible
}

output "tenant_id" {
  description = "ID del tenant de Azure AD"
  value       = var.tenant_id
  sensitive   = true # Marca el output como sensible
}

