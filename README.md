# terraform-projects
Various projects deployed via Terraform to vSphere, AWS and GCP. Each project module, whether stage or prod, calls its associated *source module* via the **terraform-reusable-modules** repository.

___

**Directory Structure**

The module directories are organised in the following way to achieve full isolation between environments;

- modules > **provider** (aws, google, vsphere)

- modules > {provider name} > **environment** (stage or prod)

- modules > {provider name} > {environment type} > **vpc** > main.tf (all virtual private cloud resources - subnets, ACLs, routing rules, VPNs)

- modules > {provider name} > {environment type} > **services** (service name) > **vms** > main.tf, variables.tf, outputs.tf

- modules > {provider name} > {environment type} > **services** (service name) > **containers** > main.tf

- modules > {provider name} > {environment type} > **datastores** (mysql, redis etc) > main.tf

- modules > {provider name} > **global** (s3, iam etc - for resources used across all environments within the provider) 

___

