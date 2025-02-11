# proxmox-homelab

## Workstation Requirements

Install packer: https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli

```shell
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```

Install packer plugins:

```shell
packer plugins install github.com/hashicorp/proxmox
```

## Creating/updating the templates

Validate the configuration:

```shell
cd templates/ubuntu-server-noble
packer validate -var-file='../../pve-credentials.pkr.hcl' './ubuntu-server-noble.pkr.hcl'
```

And then apply it:
```shell
packer build -var-file='../../pve-credentials.pkr.hcl' './ubuntu-server-noble.pkr.hcl'
```