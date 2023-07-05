terraform {
    source = "../../../../../../TerraformModules/terraform-eks/modules/eks/eks"
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

inputs = {
    prefix_name = dependency.tags.outputs.prefix_name
    tags        = dependency.tags.outputs.commons
}