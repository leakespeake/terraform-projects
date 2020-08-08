terraform {
    backend "s3" {
        bucket          = "leakespeake-terraform-state-files"
        key             = "global/s3-bucket/aws/prod/services/demo-centos/containers/terraform.tfstate"
        region          = "eu-west-2"

        dynamodb_table  = "leakespeake-terraform-state-lock"
        encrypt         = true
    }
}