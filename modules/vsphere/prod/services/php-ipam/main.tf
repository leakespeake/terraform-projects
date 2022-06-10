# VIRTUAL MACHINE MODULE
module "php-ipam-prd" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//vsphere/template-cloning/linux/ubuntu-server-20-04?ref=f06b0de"
  vcenter_password  = var.vcenter_password
  vmname            = "php-ipam-prd"
  memory            = 2048
  cpus              = 1
  disk1_size        = 20
  network           = "10.1.1.0/24_prd"
  ipv4              = ["10.1.1.250"]
  ipv4_gateway      = "10.1.1.1"
  template          = "ubuntu-server-20-04-2-20211008T070831Z"
}

# DOCKER CONTAINER MODULE
# sudo ufw allow from {PROMETHEUS_IP} to any port 8080 proto tcp
# cannot add 'depends_on' to docker provider so comment out until VM deployed or use 'tf plan -target=module.{module-name}'
module "docker-cadvisor" {
    source = "git@github.com:leakespeake/terraform-reusable-modules.git//docker-containers/cadvisor?ref=0bf8c20"
    docker_host       = "php-ipam-prd-01.int.leakespeake.com"
    container_name    = "cadvisor"
    container_version = "latest"
}