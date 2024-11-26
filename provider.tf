terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
  }

  backend "s3" {
  }
}

provider "aws" {
  region = var.region

  assume_role {
     role_arn = var.aws_iam_role_arn
  }
}