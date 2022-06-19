locals {
  cluster_name = "unir-containers-activity-3"
}

###############################################################################################
# EKS Cluster
###############################################################################################
module "node_mongo_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name                    = local.cluster_name
  cluster_version                 = "1.21"
  create_cloudwatch_log_group     = false
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  vpc_id                          = data.aws_vpc.default.id
  subnet_ids                      = data.aws_subnets.default.ids

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  eks_managed_node_groups = {
    default = {
      cluster_version = "1.21"
      min_size        = 1
      max_size        = 2
      desired_size    = 1
      instance_types  = ["t3.medium"]
      capacity_type   = "SPOT"
    }
  }

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_control_plane = {
      description                   = "From control plane"
      protocol                      = "tcp"
      from_port                     = 1025
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
}

###############################################################################################
# AWS Load Balancer Controller
# See: https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
###############################################################################################
module "aws_load_balancer_controller" {
  source = "./aws-load-balancer"

  cluster_name                       = local.cluster_name
  cluster_endpoint                   = module.node_mongo_cluster.cluster_endpoint
  cluster_certificate_authority_data = module.node_mongo_cluster.cluster_certificate_authority_data
  oidc_provider_arn                  = module.node_mongo_cluster.oidc_provider_arn
  oidc_provider                      = module.node_mongo_cluster.oidc_provider
}
