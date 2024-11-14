terraform {
  source = "git@github.com:marquesmateus93/terraform-eks.git//modules/openid//.?ref=dev"
}

include {
  path = find_in_parent_folders()
}

dependency "tags" {
  config_path = "../tags"

  mock_outputs = {
    prefix_name = "dummy_name"
    environment = "development"
    powered_by  = "terraform"
    creator_id  = get_aws_caller_identity_user_id()
  }
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    oidc                  = "https://oidc.eks.us-east-5.amazonaws.com/id/DUMMYDA19E358DUMMY92A6DC21DFB80A"
    oidc_without_protocol = "oidc.eks.us-east-5.amazonaws.com/id/DUMMY7A19E358DUMMY92A6DC21DFB80A"
    thumbprint            = "dummy48a9960b14926dummy702e22da2b0ab7280"
  }
}

inputs = {
  prefix_name           = dependency.tags.outputs.prefix_name
  oidc                  = dependency.eks.outputs.oidc
  oidc_without_protocol = dependency.eks.outputs.oidc_without_protocol
  thumbprint_list       = [
    dependency.eks.outputs.thumbprint
  ]

  tags = {
    environment = dependency.tags.outputs.environment
    creator_id  = dependency.tags.outputs.creator_id
    powered_by  = dependency.tags.outputs.powered_by
  }
}