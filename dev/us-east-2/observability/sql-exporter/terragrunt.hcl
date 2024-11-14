terraform {
    source = "git@github.com:marquesmateus93/terraform-eks.git//modules/observability/sql-exporter//.?ref=dev"
}

include {
  path = find_in_parent_folders("terragrunt-eks-helm.hcl")
}

dependency "tags" {
    config_path = "../../tags"

    mock_outputs = {
    prefix_name = "dummy_name"
    environment = "dev"
    powered_by  = "terraform"
    creator_id  = get_aws_caller_identity_user_id()
    }
}

dependency "eks" {
    config_path = "../../eks"

    mock_outputs = {
      cluster_name  = "cluster-eks-dev"
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
    is_enabled      = false
    prefix_name     = dependency.tags.outputs.prefix_name

    deployment = {
      namespace                     = basename(get_terragrunt_dir())
      replicas                      = "1"
      rollingupdate_maxsurge        = "0"
      rollingupdate_maxunavailable  = "1"
      image                         = "ghcr.io/justwatchcom/sql_exporter:latest"
      port                          = "9237"
      resources_limits_cpu          = "250m"
      resources_limits_memory       = "32Mi"
      resources_requests_cpu        = "5m"
      resources_requests_memory     = "16Mi"
    }

    configmap_job_query = yamldecode(file("${get_terragrunt_dir()}/files/configmap_query.yaml"))

    rds = {
      instance_name = "mssqlserver-dev"
      base_name     = "base-dev"
    }

    oidc_provider = dependency.openid.outputs.oidc_provider

    tags = {
        environment = dependency.tags.outputs.environment
        creator_id  = dependency.tags.outputs.creator_id
        powered_by  = dependency.tags.outputs.powered_by
    }
}