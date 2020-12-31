# For stage services, use the latest available public ami for fedora coreos (stable)
# For production services, state specific versions (packer templates unrequired - docker pre-installed)
data "aws_ami" "fcos-stable-latest" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["fedora-coreos-*"]
  }

  filter {
    name   = "description"
    values = ["Fedora CoreOS stable*"]
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

  owners = ["125523088429"] 
}

# Use the ct_config data source to read the yaml config and transpile as ignition json format - to be interpreted by fedora coreos 
data "ct_config" "boot_config" {
  content = data.template_file.fcos.rendered
  strict = true
  pretty_print = true
}

# Load the contents of the template file (bootstrap-fcos.yaml) and state the variables for interpolation within the template (DRY)
data "template_file" "fcos" {
  template = file("${path.module}/bootstrap-${var.os_distro}.${var.file_ext}")
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
