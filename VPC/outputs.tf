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

output "private_subnet_ids" {
  description = "The CIDR block of the VPC"
  value       = try(module.vpc.private_subnets, null)
}