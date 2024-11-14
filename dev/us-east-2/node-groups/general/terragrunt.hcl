terraform {
  source = "git@github.com:marquesmateus93/terraform-eks.git//modules/node-groups/general//.?ref=dev"
}

include {
  path = find_in_parent_folders()
}

locals {
  environment = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  environment_name  = local.environment.locals.environment_name
  eks_version       = local.environment.locals.eks_version
}

dependency "tags" {
  config_path = "../../tags"

  mock_outputs = {
    prefix_name = "dummy_name"
    environment = local.environment_name
    powered_by  = "terraform"
    creator_id  = get_aws_caller_identity_user_id()
  }
}

dependency "eks" {
  config_path = "../../eks"

  mock_outputs = {
    cluster_name  = "dummy-eks-${local.environment_name}"
    eks_version   = local.eks_version
  }
}

inputs = {
  prefix_name   = dependency.tags.outputs.prefix_name
  cluster_name  = dependency.eks.outputs.cluster_name

  eks_version   = dependency.eks.outputs.eks_version

  ami_type      = "AL2_x86_64"
  capacity_type = "ON_DEMAND"

  instance_types = {
    non_production  = ["t3.medium"]
    production      = ["t3.medium"]
  }

  disk_space = "40"

  scaling_config = {
    desired_size = "2"
    max_size     = "2"
    min_size     = "0"
  }

  max_unavailable = "1"

  subnets   = [
    "marques-vpc-private-subnet"
  ]

  policies = [
    "AmazonEKSWorkerNodePolicy",
    "AmazonEKS_CNI_Policy",
    "AmazonEC2ContainerRegistryReadOnly"
  ]

  tags = {
    environment = dependency.tags.outputs.environment
    creator_id  = dependency.tags.outputs.creator_id
    powered_by  = dependency.tags.outputs.powered_by
  }
}