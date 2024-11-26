module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.4.0"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  iam_role_use_name_prefix = false
  iam_role_name = "${var.cluster_name}-role"

  cluster_addons = {
    kube-proxy = {}
    coredns    = {}
    vpc-cni    = {
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          WARM_IP_TARGET = var.warm_ip_target
          MINIMUM_IP_TARGET  = var.minimum_ip_target
        }
      })
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids

  create_cluster_security_group = true

  cluster_security_group_additional_rules = {
    ingress_all = {
      description                = "Cluster all ingress"
      protocol                   = "-1"
      from_port                  = 0
      to_port                    = 0
      cidr_blocks                = ["0.0.0.0/0"]
      type                       = "ingress"
      source_node_security_group = false
    }
    egress_all = {
      description      = "Cluster all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  create_node_security_group = false

  eks_managed_node_group_defaults = {
    instance_types = ["m4.xlarge"]
  }

  eks_managed_node_groups = {
    eks_node_group = {
      name            = var.node_group_name
      use_name_prefix = true
      
      subnet_ids = var.subnet_ids

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size

      iam_role_use_name_prefix = false
      iam_role_name            = "eks-managed-node-group-${var.cluster_name}"
      
      capacity_type        = "ON_DEMAND"
      force_update_version = true
      
      disable_api_termination = false
      enable_monitoring       = true

      labels = {
        eks = "true"
      }

      update_config = {
        max_unavailable_percentage = 50 # or set max_unavailable
      }

      ebs_optimized = true
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = var.eks_node_disk_size
            volume_type           = "gp3"
            iops                  = "3000"
            throughput            = "150"
            encrypted             = "true"
            kms_key_id            = "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alias/aws/ebs"
            delete_on_termination = true
          }
        }
      }

      tags = merge(var.tags, { backup-policy = "no-cv-backup" })
    }
  }

  access_entries = {
    # One access entry with a policy associated
    cluster_admin_1 = {
      kubernetes_groups = []
      principal_arn     = var.access_entry_admin_arn

      policy_associations = {
        admin_1 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
        admin_2 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    },
    cluster_admin_2 = {
      kubernetes_groups = []
      principal_arn     = var.aws_iam_role_arn

      policy_associations = {
        admin_1 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
        admin_2 = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }

  tags = var.tags
}

module "lb_role" {
 source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

 role_name                              = var.lb_role_name
 attach_load_balancer_controller_policy = true

  oidc_providers = {
      main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
      }
  }
 }

 module "flask_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = var.app_role_name
  role_policy_arns = {
    policy = module.flask_iam_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${var.app_name}:${var.app_name}-sa"]
    }
  }
}

module "flask_iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "${var.app_name}_policy"
  path        = "/"
  description = "${var.app_name} Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
