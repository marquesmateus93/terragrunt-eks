terraform {
  source = "git@github.com:marquesmateus93/terraform-eks.git//modules/eks//.?ref=dev"
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
  config_path = "../tags"

  mock_outputs = {
    prefix_name = "dummy_name"
    environment = local.environment_name
    powered_by  = "terraform"
    creator_id  = get_aws_caller_identity_user_id()
  }
}

inputs = {
  prefix_name = dependency.tags.outputs.prefix_name

  eks_version = local.eks_version

  policies = [
    "AmazonEKSClusterPolicy",
    "AmazonEKSVPCResourceController"
  ]

  api_endpoint = {
    public               = "true"
    private              = "false"
    public_access_cidrs  = ["0.0.0.0/0"]
  }

  log_types = []

  kubernetes_network_config = {
    service_ipv4_cidr = "172.20.0.0/16"
    ip_family         = "ipv4"
  }

  subnets     = [
    "marques-vpc-public-subnet",
    "marques-vpc-private-subnet"
  ]

  kubernetes_network_config = {
    service_ipv4_cidr = "10.100.0.0/16"
    ip_family         = "ipv4"
  }

  tags = {
    environment = dependency.tags.outputs.environment
    creator_id  = dependency.tags.outputs.creator_id
    powered_by  = dependency.tags.outputs.powered_by
  }
}