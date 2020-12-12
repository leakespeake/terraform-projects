module "docker-bb-exporter" {
    source = "git@github.com:leakespeake/terraform-reusable-modules.git//docker-containers/blackbox-exporter?ref=c85d8f2"
    docker_host       = "ubuntu-packer-apache01.leakespeake.com"
    container_name    = "blackbox"
    container_version = "blackbox-exporter-0.17.0"
}