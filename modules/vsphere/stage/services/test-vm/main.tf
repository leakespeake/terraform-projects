# parent module for temporary vm to test ansible playbooks
module "ansible-test" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//vsphere/template-cloning/linux/ubuntu-server-20-04?ref=26decc2"

  vcenter_password  = var.vcenter_password
  
  vmname            = "ansible-test"

  network           = "10.2.2.0/24_stg"
  
  ipv4              = ["10.2.2.80"]
  
  ipv4_gateway      = "10.2.2.1"

  template          = "ubuntu-server-20-04-2-20211008T070831Z"
}
