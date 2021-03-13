# PROVIDER VARIABLES

variable "region" {
  description = "The region to set for the aws provider in versions.tf"
  type        = string
  default     = "eu-west-2"
}

# RESOURCE VARIABLES

variable "os_distro" {
  description = "Choose 'centos' or 'ubuntu' to load the appropriate template file for variable interpolation of bootstrap-{os}.sh"
  default     = "ubuntu"
}

variable "file_ext" {
  description = "Choose sh or yaml to load the appropriate template file for variable interpolation of bootstrap-{os}.sh"
  default     = "sh"
}

# SECURITY GROUP VARIABLES

variable "service_port1" {
  description = "The first port intended to allow access to the running service - add additional as required _port2, _port3 etc"
  type        = number
  default     = 8081
}

variable "access_port" {
  description = "SSH"
  type        = number
  default     = 22
}

variable "docker_api_port" {
  description = "The remote Docker API - allowing comms to the Docker daemon"
  type        = number
  default     = 2376
}