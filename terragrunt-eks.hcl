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
        data "aws_eks_cluster" "eks" {
            name = "Dev-Marques-Ops-eks"
        }

        data "aws_eks_cluster_auth" "eks" {
            name = data.aws_eks_cluster.eks.id
        }

        provider "kubernetes" {
            host                    = data.aws_eks_cluster.eks.endpoint
            cluster_ca_certificate  = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
            token                   = data.aws_eks_cluster_auth.eks.token
        }

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