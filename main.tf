module "vpc" {
  source = "./VPC"
  vpc_name = "vpc-${var.project}"
  vpc_cidr = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_nat_gateway = true
  tags = var.tags
}

module "eks" {
  source = "./EKS"
  
  cluster_name           = "${var.project}-eks-cluster"
  app_name               = var.project 
  lb_role_name           = "${var.project}_eks_lb_role"
  app_role_name          = "${var.project}_role" 
  cluster_version        = var.cluster_version
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_subnet_ids
  access_entry_admin_arn = var.access_entry_admin_arn
  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  aws_iam_role_arn       = var.aws_iam_role_arn
  node_group_name        = "eks_${var.project}"
  min_size               = var.min_size_eks
  max_size               = var.max_size_eks
  desired_size           = var.desired_size_eks
  warm_ip_target         = var.warm_ip_target
  minimum_ip_target      = var.minimum_ip_target
  tags                   = var.tags
}