terraform {
    source = "../../../../../../TerraformModules/terraform-eks/modules/bastion/bastion"
}

include {
    path = find_in_parent_folders()
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

dependency "security_group" {
    config_path = "../security_group"
}

dependency "key_pair" {
    config_path = "../key_pair"
}

inputs = {
    prefix_name         = dependency.tags.outputs.prefix_name
    security_group_id = dependency.security_group.outputs.security_group_id
    key_pair_name       = dependency.key_pair.outputs.key_pair_id
    is_bastion_enable   = dependency.key_pair.outputs.is_bastion_enable
    tags                = dependency.tags.outputs.commons
}