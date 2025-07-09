#!/bin/bash 

set -e

cd terraform || exit 1
terraform init
terraform apply -auto-approve
terraform output -json > ../ansible/tf_output.json
cd ../ansible || exit
python3 generate_inventory.py
ansible-playbook -i inventory.ini playbook.yml

