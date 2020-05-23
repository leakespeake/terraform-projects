output "image_id" {
  value       = data.aws_ami.ubuntu-latest.id
  description = "The latest Ubuntu ami image id"
}

output "instance_ids" {
 value = "${module.demo_ec2.*.instance_id}"
}

output "private_ips" {
 value = "${module.demo_ec2.*.private_ip}"
}

output "public_ips" {
 value = "${module.demo_eip.*.elastic_address}"
}

output "hostnames" {
 value = "${module.demo_r53_record.hostnames}"
}

output "volume_id" {
 value = "${module.demo_ebs.volume_id}"
}