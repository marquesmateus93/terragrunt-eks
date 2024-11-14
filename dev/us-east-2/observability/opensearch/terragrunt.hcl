terraform {
    source = "git@github.com:marquesmateus93/terraform-eks.git//modules/observability/opensearch//.?ref=dev"
}

include {
  path = find_in_parent_folders("terragrunt-eks-helm.hcl")
}

locals {
  environment = read_terragrunt_config(find_in_parent_folders("env.hcl"))
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

    mock_outputs = {
    cluster_name          = "iaris-eks-development"
    oidc_without_protocol = "oidc.eks.us-east-5.amazonaws.com/id/DUMMY7A19E358DUMMY92A6DC21DFB80A"
    }
}

dependency "openid" {
  config_path = "../../openid"

  mock_outputs = {
    oidc_provider = "arn:aws:iam::000000000000:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/DUMMYDA19E358DUMMY92A6DC21DFB80A"
  }
}

dependency "addons-alb-controller" {
  config_path   = "../../addons/alb-controller"
  skip_outputs  = true
}

dependency "addons-cluster-autoscaler" {
  config_path   = "../../addons/cluster-autoscaler"
  skip_outputs  = true
}

dependency "addons-csi" {
  config_path   = "../../addons/csi"
  skip_outputs  = true
}

dependency "addons-keda" {
  config_path   = "../../addons/keda"
  skip_outputs  = true
}

dependency "addons-metagpu" {
  config_path   = "../../addons/metagpu"
  skip_outputs  = true
}

dependency "addons-nginx-controller" {
  config_path   = "../../addons/nginx-controller"
  skip_outputs  = true
}

dependency "addons-secrets-store-csi-driver" {
  config_path   = "../../addons/secrets-store/csi-driver"
  skip_outputs  = true
}

dependency "addons-secrets-store-secrets-manager" {
  config_path   = "../../addons/secrets-store/secrets-manager"
  skip_outputs  = true
}

inputs = {
    is_enabled      = false
    prefix_name     = dependency.tags.outputs.prefix_name
    engine_version  = "OpenSearch_2.13"

    cluster_config = {
      instance_type   = "t3.medium.search"
      instance_count  = "1"
    }

    ebs = {
      ebs_enabled = true
      iops        = "3000"
      throughput  = "125"
      volume_size = "100"
      volume_type = "gp3"
    }

    subnets         = []

    encrypt_at_rest = true

    domain_endpoint_options = {
        enforce_https         = true
        tls_security_policy   = "Policy-Min-TLS-1-0-2019-07"
    }

    node_to_node_encryption = true

    advanced_security_options = {
      enabled                         = true
      anonymous_auth_enabled          = false
      internal_user_database_enabled  = true
    }

    saml_options = {
      enabled                 = true
      entity_id               = "https://portal.sso.us-east-1.amazonaws.com/saml/assertion/MTI4Njg0Nzg1ODcyX2lucy0wZDkzM2RkNzM3YjZmZGQ4"
      metadata_content        = file("${get_terragrunt_dir()}/files/metadata_content.xml")
      roles_key               = "Role"
      master_backend_role     = "f45844e8-8071-705a-6155-8bda77d5e122"
      session_timeout_minutes = "180"
    }

    secret_string = {
      username_key_name = "opensearch_username"
      password_key_name = "opensearch_password"
    }

    tags = {
        environment = dependency.tags.outputs.environment
        creator_id  = dependency.tags.outputs.creator_id
        powered_by  = dependency.tags.outputs.powered_by
    }
}