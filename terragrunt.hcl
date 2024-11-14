locals {
  env     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  prefix_name       = local.account.locals.prefix_name
  account_id        = local.account.locals.account_id
  region_name       = local.region.locals.region_name
  environment_name  = local.env.locals.environment_name
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
        provider "aws" {
          region              = "${local.region_name}"
          allowed_account_ids = [
              "${local.account.locals.account_id}"
          ]
        }
    EOF
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.prefix_name}-${local.environment_name}-${local.account_id}-${local.region_name}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region_name
    dynamodb_table = local.prefix_name
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}