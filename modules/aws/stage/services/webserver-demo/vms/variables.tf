variable "region" {
  description = "The region to run the EC2 Instances in"
  type        = string
  default     = "us-east-2"
}

variable "service_port1" {
  description = "The port"
  type        = number
  default     = 8080
}

variable "access_port" {
  description = "The port"
  type        = number
  default     = 22
}