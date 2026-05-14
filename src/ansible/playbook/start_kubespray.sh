#!/bin/bash

VENV_PATH="./.venv"
VENV_REQUIREMENTS="venv_requirements.txt"
# Python interpreter to use, required version >=3.12
PYTHON_CMD="python3.12"

if [ ! -d "$VENV_PATH" ]; then
    "$PYTHON_CMD" -m venv "$VENV_PATH"
fi

"$VENV_PATH/bin/pip" install -r "$VENV_REQUIREMENTS" --quiet

source .venv/bin/activate

ansible-galaxy install -r requirements.yaml

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519

ansible-playbook -i inventory/inventory.ini -b main.yaml -v