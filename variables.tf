################################################################################
# Shared variables
################################################################################

variable "aws_iam_role_arn" {
  type    = string
  default = ""
  description = "The IAM role with the permission to deploy all the required AWS resources"
}

variable "project" {
  default     = ""  
  type        = string
  description = "Terrform project"
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

variable "tags" {
    default     = {}
    type        = map
    description = "The tags to be applied to the aws resources"
}

################################################################################
# VPC variables
################################################################################

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

################################################################################
# EKS variables
################################################################################

variable "cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.27`)"
  type        = string
  default     = "1.29"
}

variable "access_entry_admin_arn" {
  description = "ARN of the role that gets admin privilileges to the EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "The public IP addresses that can access the EKS API groups"
  type        = list("string")
  default     = [""]
}

variable "min_size_eks" {
  description = "minimum number of ec2 instances"
  type        = number
  default     = 1
}

variable "max_size_eks" {
  description = "maximum number of ec2 instances"
  type        = number
  default     = 1
}

variable "desired_size_eks" {
  description = "desired number of ec2 instances"
  type        = number
  default     = 1
}

variable "warm_ip_target" {
  description = "Use the WARM_IP_TARGET variable to make sure that you always have a defined number of available IP addresses in the L-IPAMD's warm pool."
  type        = string
  default     = "0"
}

variable "minimum_ip_target" {
  description = "Use the MINIMUM_IP_TARGET to make sure that a minimum number of IP addresses are assigned to a node when it's created. This variable is generally used with the WARM_IP_TARGET variable."
  type        = string
  default     = "0"
}