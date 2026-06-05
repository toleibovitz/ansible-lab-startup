#!/bin/bash
echo "=== 1. Installing System Prerequisites ==="
sudo dnf clean all
sudo dnf install python3 python3-pip git -y

echo "=== 2. Creating Global Python Virtual Environment ==="
mkdir -p ~/.automation
python3 -m venv ~/.automation/venv
source ~/.automation/venv/bin/activate

echo "=== 3. Upgrading Pip & Installing Core Python Libraries ==="
pip install --upgrade pip
pip install ansible paramiko secure-cookie

echo "=== 4. Installing Cisco IOS Core Automation Collection ==="
ansible-galaxy collection install cisco.ios

echo "=== 5. Configuring Shell Auto-Activation ==="
if ! grep -q "source ~/.automation/venv/bin/activate" ~/.bashrc; then
    echo "source ~/.automation/venv/bin/activate" >> ~/.bashrc
fi

echo "===================================================================="
echo " SYSTEM READY: Ansible and Cisco dependencies are completely installed."
echo " You can now clone your project repositories anywhere on this node."
echo " Run: 'source ~/.automation/venv/bin/activate' to start immediately."
echo "===================================================================="