#!/bin/bash 

# Terraform setup
cd terraform || { echo "Terraform folder not found. Exiting..."; exit 1 }
terraform init
if ! terraform apply -auto-approve; then
	echo "Terraform infrastructure deployment failed. Exiting..."
	exit 1
fi

terraform output -json > ../ansible/tf_output.json
if [[ ! -f ../ansible/tf_output.json ]]; then
	echo "Terraform output file not found. Exiting..."
	exit 1
fi


# Ansible setup
cd ../ansible || { echo "Ansible folder not found. Exiting..."; exit 1 }
if ! ansible-galaxy collection list | grep -q community.docker;  then
  ansible-galaxy collection install community.docker
fi


python3 generate_inventory.py
if [[ ! -f ../ansible/inventory.ini ]]; then
	echo "Ansible inventory file not found. Exiting..."
	exit 1
fi


if ! ansible all -m ping; then
	echo "Ansible ping failed. Exiting..."
	exit 1
fi
ansible-playbook playbook.yml

