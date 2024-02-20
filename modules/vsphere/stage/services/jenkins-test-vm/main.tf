# VIRTUAL MACHINE MODULE
module "jenkins-test" {
  source           = "github.com/leakespeake/terraform-reusable-modules//vsphere/template-cloning/linux/ubuntu-server-22-04?ref=2670890"
  //source           = "git@github.com:leakespeake/terraform-reusable-modules.git//vsphere/template-cloning/linux/ubuntu-server-22-04?ref=2670890"
  vcenter_password = var.vcenter_password // passed via Vault Secret Text Credential binding
  vmname           = "jenkins-test"
  memory           = 1024
  cpus             = 1
  network          = "10.2.2.0/24_stg"
  ipv4             = ["10.2.2.60"]
  ipv4_gateway     = "10.2.2.1"
  template         = "ubuntu-server-22-04-20220602T140217Z"
  # optionally create an additional 25GB disk1 to accompany the 15GB root disk0 
  # set boolean to 'true' after initial disk0 deployment - vsphere_virtual_machine resource is updated in-place
  disk1_create     = true
}

# DOCKER CONTAINER MODULE
# sudo ufw allow from {PROMETHEUS_IP} to any port 8080 proto tcp
# cannot add 'depends_on' to docker provider so comment out until VM deployed or use 'tf plan -target=module.{module-name}'
# module "docker-cadvisor" {
#     source = "git@github.com:leakespeake/terraform-reusable-modules.git//docker-containers/cadvisor?ref=86623b8"
#     docker_host       = "jenkins-test-01.int.leakespeake.com"
#     container_name    = "cadvisor"
#     container_version = "v0.47.2"
# }