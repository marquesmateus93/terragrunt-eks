locals {
    account_vars        = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    region_vars         = read_terragrunt_config(find_in_parent_folders("region.hcl"))
    environment_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))

    account_id    = local.account_vars.locals.account_id
    prefix_name   = local.account_vars.locals.prefix_name
    aws_region    = local.region_vars.locals.region
}

generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents  = <<EOF
        provider "aws" {
            region              = "${local.aws_region}"
            allowed_account_ids = ["${local.account_id}"]
        }
    EOF
}

remote_state {
    backend = "s3"
    config  = {
        encrypt        = true
        bucket         = "eks-${local.prefix_name}-${local.aws_region}"
        key            = "${path_relative_to_include()}/terraform.tfstate"
        region         = local.aws_region
        dynamodb_table = "terraform-locks"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}