terraform {
  source = "git@github.com:marquesmateus93/terraform-eks.git//modules/observability/cloudwatch-metrics//.?ref=dev"
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
    cluster_name  = "iaris-eks-development"
  }
}

dependency "addons-alb-controller" {
  config_path   = "../../addons/alb-controller"
  skip_outputs  = true
}

dependency "addons-cluster-autoscaler" {
  config_path   = "../../addons/cluster-autoscaler"
  skip_outputs  = true
}

dependency "addons-csi" {
  config_path   = "../../addons/csi"
  skip_outputs  = true
}

dependency "addons-keda" {
  config_path   = "../../addons/keda"
  skip_outputs  = true
}

dependency "addons-metagpu" {
  config_path   = "../../addons/metagpu"
  skip_outputs  = true
}

dependency "addons-nginx-controller" {
  config_path   = "../../addons/nginx-controller"
  skip_outputs  = true
}

dependency "addons-secrets-store-csi-driver" {
  config_path   = "../../addons/secrets-store/csi-driver"
  skip_outputs  = true
}

dependency "addons-secrets-store-secrets-manager" {
  config_path   = "../../addons/secrets-store/secrets-manager"
  skip_outputs  = true
}

inputs = {
  is_enabled    = false
  prefix_name   = dependency.tags.outputs.prefix_name

  helm = {
    repository            = "https://aws.github.io/eks-charts"
    chart                 = "aws-cloudwatch-metrics"
    namespace             = "cloudwatch-metrics"
  }

  cluster_name  = dependency.eks.outputs.cluster_name

  tags = {
    environment = dependency.tags.outputs.environment
    creator_id  = dependency.tags.outputs.creator_id
    powered_by  = dependency.tags.outputs.powered_by
  }
}