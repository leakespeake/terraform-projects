# AMAZON MACHINE IMAGE
# For stage services, use the latest available public ami for your chosen OS (stable)
# For production services, use Packer templates or (at a minimum) state specific public OS versions (stable)

# Base packages such as Docker CE and Python 3 should be baked into the Packer template for immediate Docker container & Ansible functionality
# Additional configuration to be done by Ansible to automate tasks specific to the nodes intended purpose

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

# Pull read-only data from the default vpc of the specified aws region;
data "aws_vpc" "default" {
    default = true						
} 

# Pull subnets from the default vpc (within the specified aws region);
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnet" "default" {
  count = length(data.aws_subnet_ids.default.ids)
  id    = tolist(data.aws_subnet_ids.default.ids)[count.index]
}

output "subnet_cidr_blocks" {
  value = data.aws_subnet.default.*.cidr_block
}

# The aws_route53_zone data source for the zone_id is hard coded in the source module to add records to leakespeake.com only