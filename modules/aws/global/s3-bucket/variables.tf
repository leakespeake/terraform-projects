variable "bucket_name" {
    description = "The name of the S3 bucket. Must be globally unique."
    type        = string
    default     = "leakespeake-terraform-state-files"
}

variable "table_name" {
    description = "The name of the DynamoDB table. Must be unique in this AWS account."
    type        = string
    default     = "leakespeake-terraform-state-lock"
}
