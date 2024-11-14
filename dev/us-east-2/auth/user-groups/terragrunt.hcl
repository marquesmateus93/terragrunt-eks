terraform {
  source = "git@github.com:marquesmateus93/terraform-eks.git//modules/auth/user-groups//.?ref=dev"
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
  config_path   = "../../eks"
  skip_outputs  = true
}

dependency "general" {
  config_path   = "../../node-groups/general"
  mock_outputs  = {
    general-role-node-group = "arn:aws:iam::000000000000:role/node-group"
  }
}

dependency "gpu" {
  config_path   = "../../node-groups/gpu"
  mock_outputs  = {
    behaviour-gpu-role-node-group = "arn:aws:iam::000000000000:role/node-group"
  }
}

dependency "observability" {
  config_path   = "../../node-groups/observability"
  mock_outputs  = {
    behaviour-gpu-role-node-group = "arn:aws:iam::000000000000:role/node-group"
  }
}

inputs = {
  prefix_name = dependency.tags.outputs.prefix_name

  custom_map_rules = [
    {
      groups = [
        "system:bootstrappers",
        "system:nodes"
      ]
      rolearn  = dependency.general.outputs.general-role-ng
      username = "system:node:{{EC2PrivateDNSName}}"
    },
    {
      groups = [
        "system:bootstrappers",
        "system:nodes"
      ]
      rolearn  = dependency.gpu.outputs.gpu-role-ng
      username = "system:node:{{EC2PrivateDNSName}}"
    },
    {
      groups = [
        "system:bootstrappers",
        "system:nodes"
      ]
      rolearn  = dependency.observability.outputs.observability-role-ng
      username = "system:node:{{EC2PrivateDNSName}}"
    }
  ]

  tags = {
    environment = dependency.tags.outputs.environment
    creator_id  = dependency.tags.outputs.creator_id
    powered_by  = dependency.tags.outputs.powered_by
  }
}