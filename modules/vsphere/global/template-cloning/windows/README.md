# Windows Server Deployment

This module is designed to clone and deploy VMs from a Windows Server 2019 Packer template on the on-prem vSphere environment.

It uses the source module here https://github.com/leakespeake/terraform-reusable-modules/tree/master/vsphere/template-cloning/windows which contains more information about the vCenter server and Packer template configurations.

The source module uses the **vsphere** Terraform provider to deploy within vSphere 6.5 and above. All resource arguments are configured using the DRY principle.

## Versions

- Terraform --> 0.14.7
- vSphere provider --> 1.24.3
- vSphere vCenter --> 6.7

---