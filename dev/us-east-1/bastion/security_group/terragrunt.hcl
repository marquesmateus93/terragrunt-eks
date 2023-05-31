terraform {
    source = "../../../../../../TerraformModules/terraform-eks/modules/bastion/security_group"
}

include {
    path = find_in_parent_folders()
}

dependency "tags" {
    config_path     = "../../tags"
    mock_outputs    = {
        prefix_name = "dummy_prefix"

        commons = {
            email       = "dummy_user@dummymail.com"
            account_id  = get_aws_account_id()
            environment = "dummy_env"
        }
    }
}

dependency "key_pair" {
    config_path = "../key_pair"
}

inputs = {
    prefix_name         = dependency.tags.outputs.prefix_name
    is_bastion_enable   = dependency.key_pair.outputs.is_bastion_enable
    tags                = dependency.tags.outputs.commons
}