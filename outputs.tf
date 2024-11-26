################################################################################
# VPC outputs
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(module.vpc.vpc_id, null)
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(module.vpc.vpc_arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(module.vpc.vpc_cidr_block, null)
}

################################################################################
# EKS outputs
################################################################################

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`"
  value       = module.eks.oidc_provider_arn
}