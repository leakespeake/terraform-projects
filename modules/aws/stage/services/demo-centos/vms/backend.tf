terraform {
    backend "s3" {
        bucket          = "leakespeake-terraform-state-files"
        key             = "global/s3-bucket/aws/stage/services/demo-centos/vms/terraform.tfstate"
        region          = "eu-west-2"

        dynamodb_table  = "leakespeake-terraform-state-lock"
        encrypt         = true
    }
}
