terraform {
  source = "../../../../../../terraform/modules/eks/openid"
}

include {
  path = find_in_parent_folders()
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
}

inputs = {
  prefix_name     = dependency.tags.outputs.prefix_name
  tags            = dependency.tags.outputs.commons

  oidc            = dependency.eks.outputs.oidc
  thumbprint_list = dependency.eks.outputs.thumbprint
  endpoint        = dependency.eks.outputs.endpoint
}