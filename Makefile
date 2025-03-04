ANSIBLE_DIR=ansible
PACKER_DIR=builds
TERRAFORM_DIR=terraform

# Environment Configuration
ENV ?= development
ENV_FILE=../environments/$(ENV)/environment.pkr.hcl
ANSIBLE_INVENTORY=../environments/$(ENV)/ansible

# Estrae le variabili dall'ENV_FILE e le esporta
export_env = export $$(grep -v " " "$(ENV_FILE)" | xargs)

# Additional arguments
PLAYBOOK ?= playbook.yml
EXTRA_ARGS ?= 
TEMPLATE ?= ubuntu/24-04-LTS

.PHONY: help setup clean activate

help:
	@echo "Available commands:"
	@echo ""
	@echo "ANSIBLE commands:"
	@echo "  make ansible-setup                             - Create virtual environment and install dependencies."
	@echo "  make ansible-clean                             - Enter the virtual environment."
	@echo "  make ansible-activate                          - Remove virtual environment and cached files."
	@echo "  make ansible-inventory EXTRA_ARGS='--list'          - Display Ansible inventory (with environment-specific config), e.g. EXTRA_ARGS=--list."
	@echo "  make ansible-playbook [PLAYBOOK= EXTRA_ARGS= ]      - Run an Ansible playbook (with environment-specific config)."
	@echo ""
	@echo "PACKER commands:"
	@echo "  make packer-build [TEMPLATE= ]                 - Build Packer templates with environment-specific variables."
	@echo ""
	@echo "TERRAFORM commands:"
	@echo "  make terraform-init                            - Initialize Terraform."
	@echo "  make terraform-plan                            - Generate a Terraform plan (with environment-specific variables)."
	@echo "  make terraform-apply                           - Apply the generated Terraform plan."
	@echo ""
	@echo "---------------------------"
	@echo ""
	@echo "Global arguments:"
	@echo "- ENV=development"
	@echo "- EXTRA_ARGS=\"\""

## ANSIBLE (usando il Makefile interno) ##
ansible-setup:
	@cd $(ANSIBLE_DIR) && make setup

ansible-clean:
	@cd $(ANSIBLE_DIR) && make clean

ansible-activate:
	@cd $(ANSIBLE_DIR) && make activate

ansible-inventory:
	@cd $(ANSIBLE_DIR) && $(export_env) && make exec COMMAND="ansible-inventory -i $(ANSIBLE_INVENTORY) $(EXTRA_ARGS)"

ansible-playbook:
	@cd $(ANSIBLE_DIR) && $(export_env) && make exec COMMAND="ansible-playbook -i $(ANSIBLE_INVENTORY) $(PLAYBOOK) $(EXTRA_ARGS)"

## PACKER ##
packer-build:
	@cd $(PACKER_DIR) && packer build -var-file='$(ENV_FILE)' $(EXTRA_ARGS) '$(TEMPLATE)/.'

## TERRAFORM ##
terraform-init:
	@cd $(TERRAFORM_DIR) && terraform init

terraform-plan:
	@cd $(TERRAFORM_DIR) && terraform plan --var-file='$(ENV_FILE)' -out plan $(EXTRA_ARGS)

terraform-apply:
	@cd $(TERRAFORM_DIR) && terraform apply plan $(EXTRA_ARGS)
