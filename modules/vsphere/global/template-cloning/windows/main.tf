module "win2019_servers" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//vsphere/template-cloning/windows?ref=2810fe0"

  vcenter_password  = var.vcenter_password
  
  vmname            = "dc-test"
  vmnamesuffix      = "leakespeake.local"
  folder            = "vm"
  cpus              = 4
  memory            = 4096
  
  workgroup         = "dc-test"
  admin_password    = ""
  orgname           = "Leakespeake"

  # The source module uses 'length(var.ipv4)' for the 'count' argument - additional vms will be deployed based on IP count
  ipv4              = ["10.10.0.10", "10.10.0.11"]
  ipv4_mask         = 24
  ipv4_gateway      = "10.10.0.1"
  
  dns_servers       = ["10.10.0.5", "10.10.0.6", "8.8.8.8"]
}