terraform {
  source = "../../../../../../../Dev-Marques-Ops/terraform-eks/modules/eks/addons/csi/"
  include_in_copy = [
    "**/.helmignore",
    ".helmignore",
  ]
}

include {
  path = find_in_parent_folders("terragrunt-helm.hcl")
}

dependency "tags" {
  config_path = "../../tags"
  mock_outputs    = {
    prefix_name = "dummy_prefix"

    commons = {
      email       = "dummy_user@dummymail.com"
      account_id  = get_aws_account_id()
      environment = "dummy_env"
    }
  }
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    cluster_name  = "dummy_cluster"
    eks_version   = "1.26"
  }
}

dependency "openid" {
  config_path = "../openid"

  mock_outputs = {
    openid  = "mock_openid_arn"
  }
}

inputs = {
  prefix_name = dependency.tags.outputs.prefix_name
  tags        = dependency.tags.outputs.commons

  openid                = dependency.openid.outputs.openid
  oidc_without_protocol = dependency.eks.outputs.oidc_without_protocol
}