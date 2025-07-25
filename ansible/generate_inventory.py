import json

with open("tf_output.json") as f:
    data = json.load(f)

bastion_ip = data["bastion_instance_info"]["value"]["public_ip"]
db_ip = data["db_instance_info"]["value"]["private_ip"]
web_instances = data["web_instances_info"]["value"]

lines = []
proxy_cmd = (
    f'ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null '
    f'-i ../terraform/phpapp-key ec2-user@{bastion_ip} -W %h:%p'
)

lines.append("[db]")
lines.append(
    f"db1 ansible_host={db_ip} ansible_ssh_common_args='-o ProxyCommand=\"{proxy_cmd}\"'"
)
lines.append("")

lines.append("[web]")
for web in web_instances:
    lines.append(f"{web['name']} ansible_host={web['public_ip']}")
lines.append("")

lines.append("[manager]")
lines.append("web1")
lines.append("")

lines.append("[workers]")
lines.append("web2")
lines.append("web3")
lines.append("db1")

with open("inventory.ini", "w") as f:
    f.write("\n".join(lines) + "\n")  

print("Inventory created -> inventory.ini")

