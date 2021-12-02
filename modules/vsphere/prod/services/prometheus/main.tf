module "prometheus-prd" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//vsphere/template-cloning/linux/ubuntu-server-20-04?ref=af2e82d"

  vcenter_password  = var.vcenter_password
  
  vmname            = "prometheus-prd"

  memory            = 4096

  cpus              = 2

  disk1_size        = 30

  network           = "10.1.1.0/24_prd"
  
  ipv4              = ["10.1.1.200"]
  
  ipv4_gateway      = "10.1.1.1"

  template          = "ubuntu-server-20-04-2-20211008T070831Z"
  
}