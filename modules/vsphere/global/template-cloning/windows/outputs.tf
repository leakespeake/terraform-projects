# This module uses the 'count' parameter so we now have a array of resources
# As such we must specify either the individual index in the array [0],[1],[2] or use the [*] splat expression to output all values

output "vm_name" {
    description = "The name(s) of the virtual machine(s)"
    value = module.win2019_servers[*].vm_name
}

output "vm_computer_name" {
    description = "The Windows computer name(s) of the virtual machine(s)"
    value = module.win2019_servers[*].vm_computer_name
}

output "vm_ip" {
    description = "The IP(s) of the virtual machine(s)"
    value = module.win2019_servers[*].vm_ip
}

output "vm_dns" {
    description = "The DNS servers for the virtual machine(s)"
    value = module.win2019_servers[*].vm_dns
}