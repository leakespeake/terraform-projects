# Use the latest available public ami for coreos (stable)
# For production services, state specific versions (packer templates unrequired - docker pre-installed)
data "aws_ami" "coreos-stable-latest" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }
  
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["595879546273"] 
}

# Load the contents of the template file (bootstrap.sh) and state the variables for interpolation within the template (DRY)
data "template_file" "user-data" {
  template = file("${path.module}/bootstrap-${var.os_distro}.sh")

  vars = {
    access_port   = var.access_port
    service_port1 = var.service_port1
  }
}

# Use the aws_vpc data source to pull read-only data from the default vpc of the specified aws region;
data "aws_vpc" "default" {
    default = true						
} 

# Use the aws_subnet_ids data source to look up the subnets from the default vpc (within the specified aws region);
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Use the aws_route53_zone data source to look up a hosted dns zone
data "aws_route53_zone" "leakespeake-com" {
  zone_id = "Z00447873ABJW6QTXIUIH"
}
