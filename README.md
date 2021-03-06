# play-packer-aws-provisioning
Using Packer to provision Windows servers in AWS

## Background reading:

1. [PowerShell Gallery](https://www.powershellgallery.com/packages)
2. [PowerShell modules source](https://github.com/PowerShell/)
3. [Tutorial](https://dennypc.wordpress.com/2014/12/02/vagrant-provisioning-powershell-dsc/) going through using DSC with Vagrant
4. [Tutorial series](http://www.onegeek.com.au/articles/machine-factories-part1-vagrant) going through provisioning via Virtualbox through to AWS
5. [Vagrant-DSC plugin](https://github.com/mefellows/vagrant-dsc)

## Prerequisites

1. Terraform 

- ```brew install terraform```

2. Packer 

- packer-dsc plugin

3. Vagrant

- vagrant-dsc plugin

4. jq

5. Python and pip 

6. AWS CLI

7. Graphviz (used with Terraform to show the terraform plan as a visualized graph)

8. csvkit (used to generate AWS policies for terraform)

## Setting up Packer and Terraform to build AWS images

NOTE you'll also need to add in policies for ```Terraform```. See ```./terraform``` directory.

1. Create IAM policy setting up the required permissions

  The [folling IAM policy](https://www.packer.io/docs/builders/amazon.html) is correct at time of writing:

  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateVolume",
        "ec2:DeleteVolume",
        "ec2:CreateKeypair",
        "ec2:DeleteKeypair",
        "ec2:DescribeSubnets",
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateImage",
        "ec2:CopyImage",
        "ec2:RunInstances",
        "ec2:TerminateInstances",
        "ec2:StopInstances",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume",
        "ec2:DescribeInstances",
        "ec2:CreateSnapshot",
        "ec2:DeleteSnapshot",
        "ec2:DescribeSnapshots",
        "ec2:DescribeImages",
        "ec2:RegisterImage",
        "ec2:CreateTags",
        "ec2:ModifyImageAttribute"
      ],
      "Resource": "*"
    }]
  }
  ```

  - Add in the following if you are using auto-generated passwords ( i.e. not specifying the ```winrm_password``` ):

    ```json
    "ec2:GetPasswordData"
    ```

  - If the build fails packer automatically registers the AMI. To allow this, add in the following:

    ```json
    "ec2:DeregisterImage"
    ```
  
  - Add in the following to allow the user to access the ec2 instance console log:

    ```json
    "ec2:GetConsoleOutput"
    ```

  - Add in the following as part of modifying image launch permissions
  ```json
  "ec2:ResetImageAttribute"
  ```

2. Create AWS IAM users and attach the policy created in step 1

  I usually run a separate user each for Packer and Terraform

  E.g. ```agent-packer```
  E.g. ```agent-terraform```

3. Setup AWS dotfiles

  Create an ```~/.aws/``` directory and setup the default config and credentials

  **~/.aws/config**
  ```shell
  [default]
  region=eu-west-1
  output=json
  ```

4. Setup AWS credentials for the packer build pipeline to use

  **NOTE you appear to need to setup region in the ```credentials``` file even if its specified in your ```config``` file.**

  Packer [looks for credentials](https://www.packer.io/docs/builders/amazon.html) in the following locations:

  - Hard-coded in the packer template
  - Variables in the packer template (including those resolved from command-line arguments)
  - The following environment variables
    - First ```AWS_ACCESS_KEY_ID``` then ```AWS_ACCESS_KEY```
    - First ```AWS_SECRET_ACCESS_KEY``` then ```AWS_SECRET_KEY```
  - Local AWS configuration files
    - First ```~/.aws/credentials```
    - Then based on ```AWS_PROFILE```

  e.g. to use the default credentials:

  **~/.aws/credentials
  ```shell
  [default]
  aws_access_key_id=
  aws_secret_access_key=
  region=
  ```

  e.g. to use named credentials:

  **~/.aws/credentials
  ```shell
  [foo]
  aws_access_key_id=
  aws_secret_access_key=
  region=
  ```

  ```export AWS_PROFILE=foo```

## PowerShell DSC

Packer is used to build up role specific boxes (via a build chain back to common *base* builds). These are then configurated per application using *PowerShell DSC*. 

PowerShell DSC makes it possible to declaratively set the desired state of a server, including Windows Features, Firewall rules, Web applications, etc.

DSC is powered by a large amount of third-party modules that are published by MSFT and the PowerShell community. These are available from the central PowerShell Gallery.

## Step through

1. Ensure the ```PACKER_CACHE_DIR``` environment variable is set

  Packer will use a local ```packer_cache``` directory by default for all temporary files. This includes the local file cache of ISO's specified using a url. 
  To prevent the git repository from becoming cluttered, and to allow these caches objects to be re-used across packer projects, the ```PACKER_CACHE_DIR``` environment variable needs to be set to point to a global cache directory.

  ```shell
  export PACKER_CACHE_DIR=/var/cache/packer/
  ```

2. Running the packer builds

  Example given for named ```basebox-vox``` builder

  ```shell
  packer build \
    -force                # overwrite all previous images
    -debug                # step through
    -only basebox-vbox    # only build the named builder
    packer-vbox.json      # packer build script 
    ```shell

3. Adding build to Vagrant

  The ```devbox-vbox``` builder has a ```post-processor``` to convert the build into a Vagrant ```box```.
  
  This box file can be added to Vagrant as follows:

  ```shell
  vagrant box add sample-app-1.0.0 /var/media/images/vagrant/sample-app-1.0.0/sample-app-1.0.0.box
  vagrant box list
  ```

  To remove it:

  ```shell
  vagrant box remove sample-app-1.0.0
  vagrant box list
  ```

