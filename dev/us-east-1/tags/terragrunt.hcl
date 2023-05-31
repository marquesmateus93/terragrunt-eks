terraform {
    source = "git@github.com:Dev-Marques-Ops/terraform-tags.git//modules/tags"
}

include {
    path = find_in_parent_folders()
}

inputs = {
    prefix_name = "Dev-Marques-Ops"
    environment = "development"
    commons = {
        email       = "mateusmarques1993@gmail.com"
        account_id  = get_aws_account_id()
        environment = "dev"
    }
}