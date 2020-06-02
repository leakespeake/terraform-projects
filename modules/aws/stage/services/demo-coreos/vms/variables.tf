variable "os_distro" {
  description = "Choose centos coreos or ubuntu to load the appropriate template file for variable interpolation of bootstrap-{os}.sh"
  default     = "coreos"
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
