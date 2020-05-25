# Use the latest available public ami for ubuntu 18.04
data "aws_ami" "ubuntu-latest" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

    owners = ["099720109477"] 
}

# Load the contents of the template file (bootstrap.sh) and state the variables for interpolation within the template (DRY)
data "template_file" "user_data_ubuntu" {
  template = file("${path.module}/bootstrap-ubuntu.sh")

  vars = {
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
