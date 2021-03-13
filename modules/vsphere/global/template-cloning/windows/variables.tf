# utlize [export TF_VAR_vcenter_password="value"] environment variable or pass in via -var at the command line

variable "vcenter_password" {
  description = "The vCenter server password"
  sensitive = true
}