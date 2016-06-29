# Terraform

Terraform is used to build and tear-down AWS (and other cloud provider) environments

## Setting up IAM Policies to support Terraform actions

1. policies_original.csv

  Terraform csv of required IAM policies from https://github.com/hashicorp/terraform/issues/2834

2. policies.csv

  Some corrections, some new rules and removal of unrequired columns

3. policy_template.json

  Base AWS policy template used to generate the Terraform policy rules

4. create_rules

  Shell script used to generate IAM policies based off the ```policies.csv``` export of required Terraform rules

### Generating IAM Policies

Terraform requires a comprehensive set of rules to operate. To keep the policies reasonably short (as is a requirement of AWS) and granular, the approach is to generate a policy per CRUD operation.

The ```create_rules``` shell script generates an appropriately named policy file, as well as placing the policy in the clipboard ready for pasting into the AWS console:
```shell
./create_rules CREAT
./create_rules READ
./create_rules UPDATE
./create_rules DELETE
```

## Creating instances across AWS accounts

To enable machine instances to be created using the packer generated AMI images, the backing volumes of the image must be created unencrytped.
Additionally, the launch permissions on the image must be explicitly set to allow creation from the required accounts.

## Running Terraform

All terraform commands should be run from the directory containing the Terraform configuration file (```*.tf```) which is discovered at runtime through directory scanning.

### Generating the run plan

```shell
teffaform graph | dot -Tpng > app.png
imgcat app.png
```

### Running in the infrastructure

```shell
terraform -var var1 value -var var2 value
```

### Tearing down the infrastructure

To tear down all infrastructure under the control of the local Terraform configuration file:

```shell
terraform destroy
```




