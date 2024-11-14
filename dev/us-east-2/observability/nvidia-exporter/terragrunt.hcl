terraform {
    source = "git@github.com:marquesmateus93/terraform-eks.git//modules/observability/nvidia-exporter//.?ref=dev"
}

include {
  path = find_in_parent_folders("terragrunt-eks-helm.hcl")
}

locals {
  environment       = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  environment_name  = local.environment.locals.environment_name
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
    is_enabled  = true
    prefix_name = dependency.tags.outputs.prefix_name

    nvidia-exporter = {
      repository  = "https://nvidia.github.io/dcgm-exporter/helm-charts"
      chart       = "dcgm-exporter"
      namespace   = "nvidia"
    }

    prometheus-operator-crds = {
      repository  = "https://prometheus-community.github.io/helm-charts"
      chart       = "prometheus-operator-crds"
      namespace   = "nvidia"
    }

    tags = {
        environment = dependency.tags.outputs.environment
        creator_id  = dependency.tags.outputs.creator_id
        powered_by  = dependency.tags.outputs.powered_by
    }
}