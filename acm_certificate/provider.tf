terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

provider "aws" {
  region = var.region

  assume_role {
     role_arn = var.role_arn
  }
}

provider "aws" {
  region = var.region

  assume_role {
     role_arn = var.aws_iam_role_arn_route53
  }
  
  alias = "route53"
}