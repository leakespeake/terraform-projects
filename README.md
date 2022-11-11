![tf](https://user-images.githubusercontent.com/45919758/85199891-dc84bf00-b2ea-11ea-8526-683ae893fe50.png)
# terraform-projects
Various projects deployed via Terraform to vSphere home lab and AWS. 

Each project module, whether stage or prod, calls its associated *source module* via the **terraform-reusable-modules** repository. This source repo uses tags that reflect the version of Terraform that it is currently compatible for. These tags can be used as the source ref our **terraform-projects** root modules - for example;

```
module "demo_prod_ubuntu_ec2" {
  source = "git@github.com:leakespeake/terraform-reusable-modules.git//aws/ec2?ref=v.0.14.2"
```
Deployment code in this repo, whether stage or production, have an immediate visual reference to the Terraform version they were written for at the last commit.
___

**Directory Structure**

The module directories are organised in the following way to achieve full isolation between environments;

- modules > **provider** (aws, google, vsphere)

- modules > {provider name} > **environment** (stage or prod)

- modules > {provider name} > {environment type} > **vpc** > main.tf (all vpc resources - subnets, ACLs, routing, VPNs)

- modules > {provider name} > {environment type} > **services** (service name) > **vms** > main.tf, variables.tf, outputs.tf

- modules > {provider name} > {environment type} > **services** (service name) > **containers** > main.tf

- modules > {provider name} > {environment type} > **datastores** (mysql, redis etc) > main.tf

- modules > {provider name} > **global** (s3, iam etc - for resources used across all environments within the provider) 

___

