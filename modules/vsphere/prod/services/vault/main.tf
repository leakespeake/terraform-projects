# VIRTUAL MACHINE MODULE
module "vault-prd" {
  source           = "git@github.com:leakespeake/terraform-reusable-modules.git//vsphere/template-cloning/linux/ubuntu-server-22-04?ref=ab11bc0"
  vcenter_password = var.vcenter_password
  vmname           = "vault-prd"
  memory           = 2048
  cpus             = 1
  disk1_size       = 25
  network          = "10.1.1.0/24_prd"
  ipv4             = ["10.1.1.150"]
  ipv4_gateway     = "10.1.1.1"
  template         = "ubuntu-server-22-04-20220602T140217Z"
}

# DOCKER CONTAINER MODULE
# sudo ufw allow from {PROMETHEUS_IP} to any port 8080 proto tcp
# cannot add 'depends_on' to docker provider so comment out until VM deployed or use 'tf plan -target=module.{module-name}'
module "docker-cadvisor" {
    source = "git@github.com:leakespeake/terraform-reusable-modules.git//docker-containers/cadvisor?ref=3556bef"
    docker_host       = "vault-prd-01.int.leakespeake.com"
    container_name    = "cadvisor"
    container_version = "v0.46.0"
}
