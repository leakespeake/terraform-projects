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


# Use the aws_vpc data source to pull read-only data from the default vpc in my aws account;
data "aws_vpc" "default" {
    default = true						
} 


# Use the aws_subnet_ids data source to look up the subnets from the default vpc;
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id 
}



#data "terraform_remote_state" "r53zone" {
#  backend = "consul"
#
#  config {
#    path = "trecs/terraform/aws/r53zone/terraform.tfstate"
#  }
#}
