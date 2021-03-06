# Choose "centos", "coreos" or "ubuntu" - correctly named bootstrap-{os}.sh must exist in root module directory
variable "os_distro" {
  description = "Choose centos fcos or ubuntu to load the appropriate template file for variable interpolation of bootstrap-{os}.sh"
  default     = "centos"
}

variable "file_ext" {
  description = "Choose sh or yaml to load the appropriate template file for variable interpolation of bootstrap-{os}.sh"
  default     = "sh"
}

variable "service_port1" {
  description = "The first port intended to allow access to the running service - add additional as required _port2, _port3 etc"
  type        = number
  default     = 8080
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