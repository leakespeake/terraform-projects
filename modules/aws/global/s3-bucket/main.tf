# Allow any Terraform 12.x version - show via; terraform version
terraform {
  required_version = ">= 0.12, < 0.13"
}

# Set the provider as AWS and allow any 2.x version - show via; terraform version
provider "aws" {
    region = "eu-west-2"
    version = "~> 2.0"
}

# Create the S3 BUCKET
resource "aws_s3_bucket" "terraform_state" {
    bucket = var.bucket_name

    # Prevent accidental deletion of the s3 bucket. Comment out this block for 'terraform destroy' to remove it
    #lifecycle {
    #    prevent_destroy = true
    #}

    # Enable versioning for full history of our state files
    versioning {
        enabled = true
    }

    # Enable server-side encryption by default
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

# Create a DYNAMODB TABLE to use for locking the state file when running 'terraform apply'
resource "aws_dynamodb_table" "terraform_locks" {
    name        = var.table_name
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
