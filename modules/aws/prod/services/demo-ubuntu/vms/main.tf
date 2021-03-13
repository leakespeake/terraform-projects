# LOCALS BLOCK - assign a name to a Terraform expression or value that are used throughout the modules
locals {
  node_count          = 1
  azs                 = ["eu-west-2a"]                          # list multiples via ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  owner               = "baz"
  environment         = "prod"
  app                 = "ubuntu-packer-apache"  
}


# EC2 INSTANCE
module "demo_prod_ubuntu_ec2" {
  source = "C:/Users/barry/Documents/github-leakespeake/terraform-reusable-modules/aws/ec2"
  #source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/ec2?ref=7a86974"

  node_count        = local.node_count
  azs               = local.azs
  #aws_subnet_id     = data.aws_subnet_ids.default.ids          # lookup the default subnet ids - use this option when not specifying the private_ips in the vpc subnets
  aws_subnet_id     = "subnet-c18c0fbb"                         # ensure this subnet is associated with the availability zone specified in azs.local
  private_ips       = ["172.31.16.60", "172.31.16.61"]          # within range of subnet-c18c0fbb - number must match node_count - for use via private hosted zone leakespeake.com
  machine_ami       = data.aws_ami.packer-ubuntu-docker-ce.id   # use own packer template for prod services (with docker-ce baked in)
  aws_instance_type = "t2.micro"
  key_name          = "dem-keys-2020"
  user_data         = templatefile("${path.module}/bootstrap-${var.os_distro}.${var.file_ext}", {access_port = var.access_port, service_port1 = var.service_port1, docker_api_port = var.docker_api_port})
  os_distro         = var.os_distro
  file_ext          = var.file_ext

  owner             = local.owner
  environment       = local.environment
  app               = local.app


# EC2 INSTANCE - KEY PAIR
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPcIV7FhsEq04o9+Og2QbpRmRoX+b+CSoHiXGSEm+8psvubqMz59rVwVtHF/oD257a56KUD6S3E0xrjq+H/haYbPke4r7g/EkkVN8XFLV6E1sNZfzIpwPSsn+PVlHGtsQMwGeVoy/zq8P48BGKMyaUAylwuvX4kuZSkEpwn8ogiSJ64fR2ggyPVs4riKmIA5SFfaNY3CqnyIyRCqVSED8drDk0EyOK+04iFdZX0etpkZKHfPi79RZ6IhPdorR0vql1FLbA4at5IaOHfwUXDJK/he5zAtd3HFjNL6PSpjkO5WeQeVSSbrKNciCthYm2Fqzo9AMGEaCKlBn+cSjXCY9D barry@LAPTOP-FSQR2GTV"


# EC2 INSTANCE - SECURITY GROUP
  security_group_name   = "demo_prod_sg"
  service_port1         = 8081
  access_port           = 22
  docker_api_port       = 2376
}


# ELASTIC IP
module "demo_prod_eip" {
  source = "C:/Users/barry/Documents/github-leakespeake/terraform-reusable-modules/aws/eip"
  #source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/eip?ref=7a86974"

  node_count    = local.node_count
  instances_ids = module.demo_prod_ubuntu_ec2.instance_id
 
  owner         = local.owner
  environment   = local.environment
  app           = local.app
}


# ROUTE 53 ZONE - only required when creating a new zone - otherwise, append new records to existing zones using the module below
# module "demo_r53_zone" {
#   source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/route53zone?ref=7a86974"
#   domain_name = "new-domain.com"
# }


# ROUTE 53 RECORD CREATION - requires a module for each record as the 'count' parameter doesn't allow a 1:1 association of zone to eip
module "demo_prod_r53_record-01" {
  source = "C:/Users/barry/Documents/github-leakespeake/terraform-reusable-modules/aws/route53records"
  #source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/route53records?ref=7a86974"

  record_data = module.demo_prod_eip[*].elastic_address[0]
  node_name   = "ubuntu-packer-apache-01"
  type        = "A"
  ttl         = 300
  dns_domain  = "leakespeake.com"
}

# module "demo_prod_r53_record-02" {
#   source = "C:/Users/barry/Documents/github-leakespeake/terraform-reusable-modules/aws/route53records"
#   #source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/route53records?ref=7a86974"

#   record_data = module.demo_prod_eip[*].elastic_address[1]
#   node_name   = "ubuntu-packer-apache-02"
#   type        = "A"
#   ttl         = 300
#   dns_domain  = "leakespeake.com"
# }


# ELASTIC BLOCK STORE (EBS) VOLUME CREATION
module "demo_prod_ebs" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/ebs?ref=7a86974"

  node_count      = local.node_count
  azs             = local.azs

  ebs_volume_size = 5

  owner           = local.owner
  environment     = local.environment
  app             = local.app
}


# ELASTIC BLOCK STORE (EBS) ATTACHMENT
module "demo_prod_ebs_att" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/ebs_att?ref=7a86974"

  node_count    = local.node_count
  volume_ids    = module.demo_prod_ebs.volume_id
  instances_ids = module.demo_prod_ubuntu_ec2.instance_id
}