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

variable "bucket_name" {
    default     = ""
    type        = string
    description = "The name of the s3 bucket"
}

variable "dynamo_db" {
    default     = ""
    type        = string
    description = "The name of the DynamboDB Table"
}

variable "tags" {
    default     = {}
    type        = map
    description = "The tags to be applied to the s3 and dynamodb table"
}
