terraform {
  source = "../../../../../../terraform/modules/nameko/services"
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

inputs = {
  prefix_name = dependency.tags.outputs.prefix_name
  tags        = dependency.tags.outputs.commons
}