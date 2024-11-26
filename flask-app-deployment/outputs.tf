output "namspace" {
  description = "The namespace of flask app"
  value       = try(kubernetes_namespace_v1.flask-namespace.metadata[0].name, null)
}

output "service_account" {
  description = "The service account of flask app"
  value       = try(kubernetes_service_account_v1.service-account-flask.metadata[0].name, null)
}

output "service" {
  description = "The service of flask app"
  value = try(kubernetes_service_v1.flask_svc.metadata[0].name)
}

output "ingress" {
  description = "The ingress of flask app"
  value = try(kubernetes_ingress_v1.flask_ingress.metadata[0].name)
}

output "rbac_role" {
  description = "The rbac role of flask app"
  value = try(kubernetes_role_v1.flask_rbac_role.metadata[0].name)
}