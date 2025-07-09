#!/bin/bash 

set -e

cd terraform || exit 1
terraform init
terraform apply -auto-approve
terraform output -json > ../ansible/tf_output.json
cd ../ansible || exit 1
python3 generate_inventory.py
ansible all -m ping
ansible-playbook playbook.yml

