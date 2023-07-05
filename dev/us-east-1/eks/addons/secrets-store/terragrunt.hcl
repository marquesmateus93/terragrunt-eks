terraform {
  source = "../../../../../../../TerraformModules/terraform-eks/modules/eks/addons/secrets-store"
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
}

inputs = {
  prefix_name = dependency.tags.outputs.prefix_name
  tags        = dependency.tags.outputs.commons
}