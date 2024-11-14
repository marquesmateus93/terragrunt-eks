terraform {
  source = "git@github.com:marquesmateus93/terraform-eks.git//modules/addons/metagpu//.?ref=dev"
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
  skip_outputs  = true
}

dependency "auth-user-groups" {
  config_path   = "../../auth/user-groups"
  skip_outputs  = true
}
inputs = {
  is_enabled    = false
  prefix_name   = dependency.tags.outputs.prefix_name

  helm = {
    service_monitors = {
      repository  = "oci://128684785872.dkr.ecr.us-east-2.amazonaws.com"
      chart       = "marques-helm-service-monitors"
      namespace   = "nvidia"
    }
    metagpu = {
      repository  = "oci://128684785872.dkr.ecr.us-east-2.amazonaws.com"
      chart       = "marques-helm-metagpu"
      namespace   = "nvidia"
    }
  }
  
  tags = {
    environment = dependency.tags.outputs.environment
    creator_id  = dependency.tags.outputs.creator_id
    powered_by  = dependency.tags.outputs.powered_by
  }
}