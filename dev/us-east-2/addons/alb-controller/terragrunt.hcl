terraform {
  source = "git@github.com:marquesmateus93/terraform-eks.git//modules/addons/alb-controller//.?ref=dev"
}

include {
  path = find_in_parent_folders("terragrunt-eks-helm.hcl")
}

dependency "tags" {
  config_path = "../../tags"

  mock_outputs = {
    prefix_name = "dummy_name"
    environment = "development"
    powered_by  = "terraform"
    creator_id  = get_aws_caller_identity_user_id()
  }
}

dependency "eks" {
  config_path = "../../eks"

  mock_outputs = {
    cluster_name          = "cluster-eks-development"
    oidc_without_protocol = "oidc.eks.us-east-5.amazonaws.com/id/DUMMY7A19E358DUMMY92A6DC21DFB80A"
  }
}

dependency "openid" {
  config_path = "../../openid"

  mock_outputs = {
    oidc_provider = "arn:aws:iam::000000000000:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/DUMMYDA19E358DUMMY92A6DC21DFB80A"
  }
}

dependency "auth-user-groups" {
  config_path   = "../../auth/user-groups"
  skip_outputs  = true
}

inputs = {
  is_enabled            = true
  prefix_name           = dependency.tags.outputs.prefix_name

  helm = {
    repository  = "https://aws.github.io/eks-charts"
    chart       = "aws-load-balancer-controller"
    namespace   = "kube-system"
  }

  cluster_name          = dependency.eks.outputs.cluster_name
  oidc_provider         = dependency.openid.outputs.oidc_provider
  oidc_without_protocol = dependency.eks.outputs.oidc_without_protocol

  tags = {
    environment = dependency.tags.outputs.environment
    creator_id  = dependency.tags.outputs.creator_id
    powered_by  = dependency.tags.outputs.powered_by
  }
}