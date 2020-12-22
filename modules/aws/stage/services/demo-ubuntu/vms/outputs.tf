output "image_id" {
  value       = data.aws_ami.packer-ubuntu-docker-ce.id
  description = "Packer template ami image id"
}

output "instance_ids" {
 value = module.demo_stg_ubuntu_ec2.*.instance_id
}

output "private_ips" {
 value = module.demo_stg_ubuntu_ec2.*.private_ip
}

output "public_ips" {
 value = module.demo_stg_eip.elastic_address
}

output "hostnames" {
 value = module.demo_stg_r53_record.hostnames
}

output "volume_id" {
 value = module.demo_stg_ebs.volume_id
}