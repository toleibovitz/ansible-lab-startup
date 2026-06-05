#!/bin/bash

echo "=== 1. Registering Red Hat Developer Subscription ==="

read -p "Enter Red Hat Developer Username: " RH_USER < /dev/tty
read -sp "Enter Red Hat Developer Password: " RH_PASS < /dev/tty
echo ""

echo "Registering system with subscription-manager..."
sudo subscription-manager register --username "$RH_USER" --password "$RH_PASS" --auto-attach

if [ $? -eq 0 ]; then
    echo "SUCCESS: System registered and entitlements attached."
else
    echo "ERROR: Subscription registration failed. Checking internet connectivity or credentials."
    exit 1
fi

echo "=== 2. Installing System Prerequisites ==="
sudo dnf clean all
sudo dnf install python3 python3-pip git -y

echo "=== 3. Creating Global Python Virtual Environment ==="
mkdir -p ~/.automation
python3 -m venv ~/.automation/venv
source ~/.automation/venv/bin/activate

echo "=== 4. Upgrading Pip & Installing Core Python Libraries ==="
pip install --upgrade pip
pip install ansible paramiko secure-cookie

echo "=== 5. Installing Cisco IOS Core Automation Collection ==="
ansible-galaxy collection install cisco.ios

echo "=== 6. Configuring Shell Auto-Activation ==="
if ! grep -q "source ~/.automation/venv/bin/activate" ~/.bashrc; then
    echo "source ~/.automation/venv/bin/activate" >> ~/.bashrc
fi

echo "===================================================================="
echo " SYSTEM READY: Registered, Ansible and Cisco dependencies installed."
echo " You can now clone your project repositories anywhere on this node."
echo " Run: 'source ~/.automation/venv/bin/activate' to start immediately."
echo "===================================================================="