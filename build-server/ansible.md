Ansible is being run remotely - i.e. all playbooks are run remotely on the target machine from the packer server.
One reason for this is the lack of support in the packer-local provisioner to install galaxy dependencies

```shell
brew install ansible
ansible-galaxy install -r requirements.yaml
```


