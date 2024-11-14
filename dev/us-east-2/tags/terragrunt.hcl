terraform {
  source = "git@github.com:marquesmateus93/terraform-tags.git//modules/tags//."
}

include {
  path = find_in_parent_folders()
}

locals {
  environment = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  environment_name  = local.environment.locals.environment_name
  prefix_name       = local.account.locals.prefix_name
}

inputs = {
  prefix_name = local.prefix_name
  environment = local.environment_name
  creator_id  = get_aws_caller_identity_user_id()
}
