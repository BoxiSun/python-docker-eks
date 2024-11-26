variable "aws_iam_role_arn" {
  type    = string
  default = ""
  description = "The IAM role with the permission to deploy all the required AWS resources"
}

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

variable "vpc_name" {
  default     = ""  
  type        = string
  description = "vpc name"
}

variable "vpc_cidr" {
  default     = ""  
  type        = string
  description = "vpc cidr"
}

variable "azs" {
  default     = []  
  type        = list
  description = "availablility zones"
}

variable "private_subnets" {
  default     = []  
  type        = list
  description = "a list of private subnets cidrs"
}

variable "public_subnets" {
  default     = []  
  type        = list
  description = "a list of public subnets cidrs"
}

variable "enable_nat_gateway" {
  default     = false 
  type        = bool
  description = "create NAT gateway"
}

variable "tags" {
    default     = {}
    type        = map
    description = "The tags to be applied to the aws resources"
}

