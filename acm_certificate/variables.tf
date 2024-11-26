variable "region" {
  default     = "eu-west-1"  
  type        = string
  description = "Which region to create resources"
}

variable "role_arn" {
  default     = ""
  description = "The role user assumes to create the infrastructure"
  type        = string
}

variable "aws_iam_role_arn_route53" {
  type = string
  default = ""
  description = "The IAM role of the other AWS account where the hosted zone is"
}

variable "zone_name" { 
    default     = ""
    type        = string
    description = "The name of route53 hosted zone"
}

variable "domain_name" {
    default     = ""
    type        = string
    description = "The name of the certificate domain"
}

variable "tags" {
    default     = {}
    type        = map
    description = "The tags to be applied to the s3 and dynamodb table"
}
