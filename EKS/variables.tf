variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region"
}

variable "app_name" {
    default     = ""
    type        = string
    description = "The name of the eks application"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.27`)"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster security group will be provisioned"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the nodes/node groups will be provisioned. If `control_plane_subnet_ids` is not provided, the EKS cluster control plane (ENIs) will be provisioned in these subnets"
  type        = list(string)
  default     = []
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
    default     = {}
    type        = map
    description = "The tags to be applied to the aws eks resources"
}

variable "access_entry_admin_arn" {
  description = "IAM Role ARN that will have access to the cluster with admin privileges"
  type = string
}

variable "aws_iam_role_arn" {
  description = "the platform iam role that will have access to the cluster with admin privileges"
  type = string
}


variable "node_group_name" {
  description = "The name of the eks node group"
  type = string
  default = ""
}

variable "eks_node_disk_size" {
  description = "size of the disk for the eks nodes"
  type = number
  default = 80
}

variable "min_size" {
  description = "minimum number of ec2 instances"
  type = number
  default = 1
}

variable "max_size" {
  description = "maximum number of ec2 instances"
  type = number
  default = 1
}

variable "desired_size" {
  description = "desired number of ec2 instances"
  type = number
  default = 1
}

variable "warm_ip_target" {
  description = "Use the WARM_IP_TARGET variable to make sure that you always have a defined number of available IP addresses in the L-IPAMD's warm pool."
  type = string
  default = "0"
}

variable "minimum_ip_target" {
  description = "Use the MINIMUM_IP_TARGET to make sure that a minimum number of IP addresses are assigned to a node when it's created. This variable is generally used with the WARM_IP_TARGET variable."
  type = string
  default = "0"
}

variable "lb_role_name" {
  description = "The name of the IAM role for load balancer controller"
  type = string
  default = ""
}

variable "app_role_name" {
  description = "The name of the IAM role for the eks application"
  type = string
  default = ""
}
