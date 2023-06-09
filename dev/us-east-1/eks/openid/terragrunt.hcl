terraform {
  source = "git@github.com:marquesmateus93/terraform-eks.git//modules/eks/openid"
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
  mock_outputs = {
    oidc                  = "https://dummy.oidc.local"
    thumbprint            = run_cmd("openssl", "rand", "-hex", "20")
    oidc_without_protocol = "Dummy Thumbprint Without Protocol"
  }
}

inputs = {
  prefix_name           = dependency.tags.outputs.prefix_name
  oidc                  = dependency.eks.outputs.oidc
  thumbprint_list       = dependency.eks.outputs.thumbprint
  oidc_without_protocol = dependency.eks.outputs.oidc_without_protocol
  tags                  = dependency.tags.outputs.commons
}