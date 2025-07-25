#!/bin/bash 

set -e

cd terraform || exit 1
terraform init
terraform apply -auto-approve
terraform output -json > ../ansible/tf_output.json

cd ../ansible || exit 1
if ! ansible-galaxy collection list | grep -q community.docker;  then
  ansible-galaxy collection install community.docker
fi
python3 generate_inventory.py
ansible all -m ping
ansible-playbook playbook.yml

