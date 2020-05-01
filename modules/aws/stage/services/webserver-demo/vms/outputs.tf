output "image_id" {
  value = data.aws_ami.ubuntu-latest.id
}

# output "security_group" {
#   value = {
#     name      = aws_security_group.demo_sg.name
#     secgrp_id = aws_security_group.demo_sg.id
#   }
# }


#output "ipaddresses" {
#  value = "${module.demo_ec2.ipaddress}"
#}

#output "instance_ids" {
#  value = "${module.demo_ec2.instance_id}"
#}

#output "hostnames" {
#  value = "${module.demo_r53.hostnames}"
#}

#output "elastic_ipaddresses" {
#  value = "${module.demo_eip.elastic_address}"
#}

#output "volume_id" {
#  value = "${module.demo_ebs.volume_id}"
#}
