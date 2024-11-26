variable "region" {
  default     = "eu-west-1"  
  type        = string
  description = "Which region to create resources"
}

variable "image" {
  type    = string
  default = ""
  description = "The name of the application image"
}

variable "image_version" {
  type    = string
  default = ""
  description = "The version of the application image"
}

variable "aws_iam_role_arn" {
  type    = string
  default = ""
  description = "The IAM role with the permission to deploy all the required AWS resources"
}

variable "aws_iam_role_arn_route53" {
  type = string
  default = ""
  description = "The IAM role of the other AWS account where the hosted zone is"
}

variable "app_name" {
    default     = ""
    type        = string
    description = "The name of the eks application"
}

variable "oidc_provider_arn" {
    default     = ""
    type        = string
    description = "The arn of the EKS oidc_provider"
}

variable "tags" {
    default     = {}
    type        = map
    description = "The tags to be applied to the aws resources"
}

