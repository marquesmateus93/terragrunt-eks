terraform {
  source = "../../../../../../../TerraformModules/terraform-eks/modules/eks/node-groups/public"
}

include {
  path = find_in_parent_folders()
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

  mock_outputs = {
    cluster_name  = "dummy_cluster"
    eks_version   = "1.26"
  }
}

dependency "key_pair" {
  config_path = "../../../bastion/key_pair"

  mock_outputs = {
    key_pair_id       = "dummy_key"
    is_bastion_enable = true
  }
}

dependency "security_groups" {
  config_path     = "../../../bastion/security_group"

  mock_outputs = {
    security_groups = "dummy_security_group"
  }
}

inputs = {
  prefix_name         = dependency.tags.outputs.prefix_name
  cluster_name        = dependency.eks.outputs.cluster_name
  eks_version         = dependency.eks.outputs.eks_version
  ec2_ssh_key         = dependency.key_pair.outputs.key_pair_id
  is_bastion_enable   = dependency.key_pair.outputs.is_bastion_enable
  security_groups     = dependency.security_groups.outputs.security_group_id
  tags                = dependency.tags.outputs.commons
}