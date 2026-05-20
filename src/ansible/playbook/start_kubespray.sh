#!/bin/bash

VENV_PATH="./.venv"
VENV_REQUIREMENTS="venv_requirements.txt"
# Python interpreter to use, required version >=3.12
PYTHON_CMD="python3.12"

if [ ! -d "$VENV_PATH" ]; then
    "$PYTHON_CMD" -m venv "$VENV_PATH"
fi

source .venv/bin/activate

"$VENV_PATH/bin/pip" install -r "$VENV_REQUIREMENTS" --quiet

ansible-galaxy install -r requirements.yaml

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519

ansible-playbook -i inventory/inventory.ini -b main.yaml -v

# Add NAT ip to admin.conf and place it into ~/.kube as config
cd inventory/artifacts
NAT_IP=$(awk '/\[bastion\]/ {flag=1; next} flag && /ansible_host=/ {gsub(/.*=/,""); print; flag=0}' ../inventory\(4\).ini)
sed -i "s|server: https://[^:]*:6443|server: https://${NAT_IP}:6443|" admin.conf
if [ ! -d ~/.kube ]; then
    mkdir ~/.kube
fi
mv admin.conf ~/.kube/config