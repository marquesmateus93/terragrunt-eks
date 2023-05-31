terraform {
  source = "../../../../../../../TerraformModules/terraform-eks/modules/eks/addons/alb-controller"
  include_in_copy = [
    "**/.helmignore",
    ".helmignore",
  ]
}

include {
  path = find_in_parent_folders("terragrunt-helm.hcl")
}

dependency "tags" {
  config_path = "../../../tags"
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
  config_path = "../../eks"

  mock_outputs = {
    cluster_name  = "dummy_cluster"
    eks_version   = "1.26"
  }
}

dependency "openid" {
  config_path = "../../openid"

  mock_outputs = {
    openid  = "mock_openid_arn"
  }
}

inputs = {
  prefix_name           = dependency.tags.outputs.prefix_name
  cluster_name          = dependency.eks.outputs.cluster_name
  openid                = dependency.openid.outputs.openid
  oidc_without_protocol = dependency.eks.outputs.oidc_without_protocol
  tags                  = dependency.tags.outputs.commons
}