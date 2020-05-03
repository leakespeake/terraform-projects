# LOCALS BLOCK - assign a name to a Terraform expression to use throughout the modules
locals {
  node_count          = 2
  azs                 = "us-east-2a"
  
  owner               = "leakespeake"
  environment         = "stage"
  app                 = "demo"
  
  service_port		    = 8080
  access_port         = 22
}


# EC2 INSTANCE
module "demo_ec2" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/ec2?ref=a2cd2a5"

  node_count        = local.node_count
  azs               = local.azs
  machine_ami       = data.aws_ami.ubuntu-latest.id
  aws_instance_type = "t2.micro"
  #aws_subnet_id     = data.aws_subnet_ids.default.ids
  key_name          = "dem-keys-2020"

#bootstrap.sh - to update the apt repos, upgrade the packages, install apache / php and display a test web page
  user_data   = "${file("${path.module}/bootstrap.sh")}"
  
  owner       = local.owner
  environment = local.environment
  app         = local.app


# EC2 INSTANCE - KEY PAIR
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPcIV7FhsEq04o9+Og2QbpRmRoX+b+CSoHiXGSEm+8psvubqMz59rVwVtHF/oD257a56KUD6S3E0xrjq+H/haYbPke4r7g/EkkVN8XFLV6E1sNZfzIpwPSsn+PVlHGtsQMwGeVoy/zq8P48BGKMyaUAylwuvX4kuZSkEpwn8ogiSJ64fR2ggyPVs4riKmIA5SFfaNY3CqnyIyRCqVSED8drDk0EyOK+04iFdZX0etpkZKHfPi79RZ6IhPdorR0vql1FLbA4at5IaOHfwUXDJK/he5zAtd3HFjNL6PSpjkO5WeQeVSSbrKNciCthYm2Fqzo9AMGEaCKlBn+cSjXCY9D barry@LAPTOP-FSQR2GTV"


# EC2 INSTANCE - SECURITY GROUP
  security_group_name = "demo_sg"
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