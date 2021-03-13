# This module uses the 'count' parameter so we now have a array of resources
# As such we must specify either the individual index in the array [0],[1],[2] or use the [*] splat expression to output all values

output "image_id" {
 value       = data.aws_ami.packer-ubuntu-docker-ce.id
}

output "instance_ids" {
 value = module.demo_prod_ubuntu_ec2[*].instance_id
}

output "private_ips" {
 value = module.demo_prod_ubuntu_ec2[*].private_ip
}

output "public_ips" {
 value = module.demo_prod_eip[*].elastic_address
}

output "hostnames01" {
 value = module.demo_prod_r53_record-01.hostnames
}

# output "hostnames02" {
#  value = module.demo_prod_r53_record-02.hostnames
# }

output "volume_id" {
 value = module.demo_prod_ebs.volume_id
}

output "template_rendered" {
  value = templatefile("${path.module}/bootstrap-${var.os_distro}.${var.file_ext}",
  {
    access_port = var.access_port
    service_port1 = var.service_port1
    docker_api_port = var.docker_api_port
  })
}