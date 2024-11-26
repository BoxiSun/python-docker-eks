data "aws_caller_identity" "current" {}

data "aws_vpc" "test-vpc" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${var.app_name}"]
  }
}

# Protected subnets all avalability zones
data "aws_subnets" "private_all_az" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.test-vpc.id]
  }

  tags = {
    Name = "vpc-${var.app_name}-private-*"
  }
}

# Public subnets all avalability zones
data "aws_subnets" "public_all_az" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.test-vpc.id]
  }

  tags = {
    Name = "vpc-${var.app_name}-public-*"
  }
}

data "aws_eks_cluster" "cluster" {
  name = "${var.app_name}-eks-cluster"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "${var.app_name}-eks-cluster"
}

data "aws_lb" "flask-alb" {
  name  = "flask-alb"
  depends_on = [ kubernetes_ingress_v1.flask_ingress ]
}

data "aws_acm_certificate" "default" {
  domain      = "*.svc-neon.markets"
  most_recent = true
}

# data "aws_route53_zone" "test-domain" {
#   name         = "svc-neon.markets"
#   private_zone = false
#   provider     = aws.route53
# }

data "aws_iam_role" "lb_role" {
  name = "${var.app_name}_eks_lb_role"
}

data "aws_iam_role" "app_role" {
  name = "${var.app_name}_role" 
}