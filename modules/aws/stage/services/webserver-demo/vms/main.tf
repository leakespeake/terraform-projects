# LOCALS BLOCK - assign a name to a Terraform expression or value that are used throughout the modules
locals {
  node_count          = 1
  azs                 = "us-east-2a"
  
  owner               = "leakespeake"
  environment         = "stage"
  app                 = "demo"  
}


# EC2 INSTANCE
module "demo_ec2" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/ec2?ref=e02dda1"

  node_count        = local.node_count
  azs               = local.azs
  machine_ami       = data.aws_ami.ubuntu-latest.id
  aws_instance_type = "t2.micro"
  key_name          = "dem-keys-2020"
  user_data         = data.template_file.user_data.rendered

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
#module "demo_eip" {
#  source = "git@github.com:sky-uk/cd-devops-infra-source.git//terraform/modules-source/aws/eip?ref=6658651" ## CHANGE TO LEAKESPEAKE REPO
#
#  node_count    = "${local.node_count}"
#  instances_ids = "${module.demo_ec2.instance_id}"
#  
#  owner         = "${local.owner}"
#  environment   = "${local.environment}"
#  app           = "${local.app}"
#}
#
#
# ELASTIC BLOCK STORE (EBS) VOLUME CREATION
#module "demo_ebs" {
#  source = "git@github.com:sky-uk/cd-devops-infra-source.git//terraform/modules-source/aws/ebs?ref=6658651" ## CHANGE TO LEAKESPEAKE REPO
#
#  node_count      = "${local.node_count}"
#  azs             = "${local.azs}"
#  
#  ebs_volume_size = 20
#  
#  owner           = "${local.owner}"
#  environment     = "${local.environment}"
#  app             = "${local.app}"
#}
#
#
# ELASTIC BLOCK STORE (EBS) ATTACHMENT
#module "demo_ebs_att" {
#  source = "git@github.com:sky-uk/cd-devops-infra-source.git//terraform/modules-source/aws/ebs_att?ref=6658651" ## CHANGE TO LEAKESPEAKE REPO
#
#  node_count    = "${local.node_count}"
#  volume_ids    = "${module.demo_ebs.volume_id}"
#  instances_ids = "${module.demo_ec2.instance_id}"
#}
#
#
# ROUTE 53 ZONE AND RECORD CREATION
#module "demo_r53" {
#  source = "git@github.com:sky-uk/cd-devops-infra-source.git//terraform/modules-source/aws/route53records?ref=6658651" ## CHANGE TO LEAKESPEAKE REPO
#
#  node_count  = "${local.node_count}"
#  node_name   = "demo"
#  zone_id     = "${data.terraform_remote_state.r53zone.zone_id}"
#  type        = "A"
#  ttl         = 300
#  dns_domain  = "${data.terraform_remote_state.r53zone.domain_name}"
#  record_data = "${module.demo_ec2.ipaddress}"
#}