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
    mock_outputs = {
        security_group_id = "Dummy Security Group ID"
    }
}

dependency "key_pair" {
    config_path = "../key_pair"
    mock_outputs = {
        is_bastion_enable   = false
        key_pair_id         = "Dummy Key Pair ID"
    }
}

inputs = {
    is_bastion_enable   = dependency.key_pair.outputs.is_bastion_enable
    prefix_name         = dependency.tags.outputs.prefix_name
    security_group_id   = dependency.security_group.outputs.security_group_id
    key_pair_name       = dependency.key_pair.outputs.key_pair_id
    tags                = dependency.tags.outputs.commons
}