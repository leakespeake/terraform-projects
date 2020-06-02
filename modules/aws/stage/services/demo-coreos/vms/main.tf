# LOCALS BLOCK - assign a name to a Terraform expression or value that are used throughout the modules
locals {
  node_count          = 1
  azs                 = ["eu-west-2a"]                          # list multiple zones via ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  
  owner               = "leakespeake"
  environment         = "stage"
  app                 = "demo-coreos"  
}


# EC2 INSTANCE
module "demo_coreos_ec2" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/ec2?ref=309bc0d"

  node_count        = local.node_count
  azs               = local.azs
  #aws_subnet_id     = data.aws_subnet_ids.default.ids          # lookup the default subnet ids - use this option when not specifying the private_ips in the vpc subnets
  aws_subnet_id     = "subnet-c18c0fbb"                         # ensure this subnet is associated with the availability zone specified in azs.local
  private_ips       = ["172.31.16.10"]                          # within range of subnet-c18c0fbb - number must match node_count - for use via private hosted zone leakespeake.com
  machine_ami       = data.aws_ami.coreos-stable-latest.id
  aws_instance_type = "t2.micro"
  key_name          = "dem-keys-2020"
  user_data         = data.template_file.user-data.rendered
  os_distro         = var.os_distro

  owner             = local.owner
  environment       = local.environment
  app               = local.app


# EC2 INSTANCE - KEY PAIR
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPcIV7FhsEq04o9+Og2QbpRmRoX+b+CSoHiXGSEm+8psvubqMz59rVwVtHF/oD257a56KUD6S3E0xrjq+H/haYbPke4r7g/EkkVN8XFLV6E1sNZfzIpwPSsn+PVlHGtsQMwGeVoy/zq8P48BGKMyaUAylwuvX4kuZSkEpwn8ogiSJ64fR2ggyPVs4riKmIA5SFfaNY3CqnyIyRCqVSED8drDk0EyOK+04iFdZX0etpkZKHfPi79RZ6IhPdorR0vql1FLbA4at5IaOHfwUXDJK/he5zAtd3HFjNL6PSpjkO5WeQeVSSbrKNciCthYm2Fqzo9AMGEaCKlBn+cSjXCY9D barry@LAPTOP-FSQR2GTV"


# EC2 INSTANCE - SECURITY GROUP
  security_group_name   = "demo_sg"
  service_port1         = 8081
  access_port           = 22
}


# ELASTIC IP
module "demo_eip" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/eip?ref=0b3c80d"

  node_count    = "${local.node_count}"
  instances_ids = "${module.demo_coreos_ec2.instance_id}"
 
  owner         = "${local.owner}"
  environment   = "${local.environment}"
  app           = "${local.app}"
}


# # ROUTE 53 ZONE - only required when creating a new zone - otherwise, append new records to existing zones using the module below
# module "demo_r53_zone" {
#   source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/route53zone?ref=0b3c80d"
#   domain_name = "mydomain.com"
# }


# ROUTE 53 RECORD CREATION
module "demo_r53_record" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/route53records?ref=639722f"

  node_count  = "${local.node_count}"
  node_name   = "demo-coreos"
  zone_id     = "${data.aws_route53_zone.leakespeake-com.zone_id}"
  type        = "A"
  ttl         = 300
  dns_domain  = "leakespeake.com"
  record_data = "${module.demo_eip.elastic_address}"
}


# ELASTIC BLOCK STORE (EBS) VOLUME CREATION
module "demo_ebs" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/ebs?ref=cd42087"

  node_count      = "${local.node_count}"
  azs             = "${local.azs}"

  ebs_volume_size = 10

  owner           = "${local.owner}"
  environment     = "${local.environment}"
  app             = "${local.app}"
}


# ELASTIC BLOCK STORE (EBS) ATTACHMENT
module "demo_ebs_att" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/ebs_att?ref=cd42087"

  node_count    = "${local.node_count}"
  volume_ids    = "${module.demo_ebs.volume_id}"
  instances_ids = "${module.demo_coreos_ec2.instance_id}"
}