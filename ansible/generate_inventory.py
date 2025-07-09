import json

INVENTORY_FILE = "inventory.ini"

with open("tf_output.json") as f:
    data = json.load(f)

bastion_ip = data["bastion_instance_info"]["value"]["public_ip"]
db_ip = data["db_instance_info"]["value"]["private_ip"]
web_instances = data["web_instances_info"]["value"]

lines = []

lines.append("[bastion]")
lines.append(f"bastion ansible_host={bastion_ip}")
lines.append("")

proxy_cmd = f'ssh ec2-user@{bastion_ip} -W %h:%p'
lines.append("[db]")
lines.append(
    f"db ansible_host={db_ip} ansible_ssh_common_args='-o ProxyCommand=\"{proxy_cmd}\"'"
)
lines.append("")

lines.append("[web]")
for web in web_instances:
    lines.append(f"{web['name']} ansible_host={web['public_ip']}")

with open("inventory.ini", "w") as f:
    f.write("\n".join(lines) + "\n")  

print(f"Inventory created -> inventory.ini")

