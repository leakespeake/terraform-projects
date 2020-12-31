output "image_id" {
  value       = data.aws_ami.fcos-stable-latest.id
  description = "The latest stable CoreOS ami image id"
}

output "instance_ids" {
 value = module.demo_coreos_prod_ec2.*.instance_id
}

output "private_ips" {
 value = module.demo_coreos_prod_ec2.*.private_ip
}

output "public_ips" {
 value = module.demo_coreos_prod_eip.elastic_address
}

output "hostnames" {
 value = module.demo_coreos_prod_r53_record.hostnames
}

output "volume_id" {
 value = module.demo_coreos_prod_ebs.volume_id
}