# Choose "centos", "coreos" or "ubuntu" - correctly named bootstrap-{os}.sh must exist in root module directory
variable "os_distro" {
  description = "Choose centos coreos or ubuntu to load the appropriate template file for variable interpolation of bootstrap-{os}.sh"
  default     = "centos"
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
