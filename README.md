# proxmox-homelab

## References

For building the templates I took huge inspiration from the following projects:
- https://github.com/vmware-samples/packer-examples-for-vsphere (doc: https://vmware-samples.github.io/packer-examples-for-vsphere/getting-started)
- https://github.com/ChristianLempa/boilerplates/tree/main/packer/proxmox

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

Install Terraform: https://developer.hashicorp.com/terraform/install

```shell
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

## Creating/updating the templates

Validate the configuration:

```shell
packer validate -var-file='environments/example.tfvars' 'builds/ubuntu/24-04-LTS/.'
```

And then apply it:
```shell
packer build -var-file='environments/example.tfvars' 'builds/ubuntu/24-04-LTS/.'
```

Per sostituire il template già presente utilizzare l'opzione `-force`.

## Creating/updating the infrastructure

Next, run the command terraform init. This will initialize a new working directory for use with Terraform. More can be read about this command here.

```shell
cd terraform
terraform init
```

Now that we have an initialized project, let's run a terraform plan command.  This will give us output indicating what will be created, modified, or destroyed by Terraform.
It is generally a good idea to specify an -out file to save this generated plan to, rather than relying on a speculative plan.

```shell
cd terraform
terraform plan --var-file='../environments/example.tfvars' -out plan
```

After all of your hard work, you are now ready to apply your plan and spin up a VM within your Proxmox server!
Doing so is as simple as running the command terraform apply plan.  This will use our saved plan file and apply it.

Assuming things run successfully, you should see the following output: `Apply complete! Resources: 1 added, 0 changed, 0 destroyed.`

```shell
terraform apply plan
```

## Ansible temporary instructions

```shell
python3 -m pip install -r requirements.txt --break-system-packages
```
