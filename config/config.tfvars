################################################################################
# Shared variables
################################################################################
aws_iam_role_arn = "arn:aws:iam::972156694227:role/app-shared-role"
aws_iam_role_arn_route53 = "arn:aws:iam::972156694227:role/app-shared-role"

project         = "flask"
tags            = {
                    terraform = "true"
                    project = "flask"
                  }

################################################################################
# VPC variables
################################################################################
vpc_cidr        = "10.111.160.0/20"
azs             = ["eu-west-1a", "eu-west-1b"]
private_subnets = ["10.111.161.0/25", "10.111.162.0/25"]
public_subnets  = ["10.111.163.0/25", "10.111.164.0/25"]

################################################################################
# EKS variables
################################################################################
access_entry_admin_arn = "arn:aws:iam::972156694227:role/aws-reserved/sso.amazonaws.com/eu-west-1/AWSReservedSSO_PRD-ALLTEAMS-FULLACCESS_514a20e01f35d01f"
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"] //This is for test purpose. In real case, it should be limited

min_size_eks     = 2
max_size_eks     = 4
desired_size_eks = 4
minimum_ip_target = "2"
warm_ip_target = "4"

################################################################################
# EKS application variables
################################################################################
app_name = "flask"