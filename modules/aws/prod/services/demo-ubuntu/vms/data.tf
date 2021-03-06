# For stage services, use the latest available public ami for ubuntu 20.04
# For production services, state specific versions or use own packer template - owners = ["self"]
data "aws_ami" "packer-ubuntu-docker-ce" {
  
  filter {
    name   = "name"
    values = ["packer-aws-ubuntu-20-04 1593858290"]
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

  owners = ["self"] 
}

# Use the aws_vpc data source to pull read-only data from the default vpc of the specified aws region;
data "aws_vpc" "default" {
    default = true						
} 

# Use the aws_subnet_ids data source to look up the subnets from the default vpc (within the specified aws region);
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# The aws_route53_zone data source for the zone_id exists in the source module - only intend to add records to leakespeake.com