#!/bin/bash

RH_USER="${RH_USER:-}"
RH_PASS="${RH_PASS:-}"

echo "=== 1. Registering Red Hat Developer Subscription ==="

if [ -z "$RH_USER" ]; then
    read -p "Enter Red Hat Developer Username: " RH_USER
fi

if [ -z "$RH_PASS" ]; then
    read -s -p "Enter Red Hat Developer Password: " RH_PASS
    echo
fi

echo "Registering system with subscription-manager..."
if subscription-manager identity >/dev/null 2>&1; then
    echo "System already registered."
elif subscription-manager register \
        --username "$RH_USER" \
        --password "$RH_PASS" \
        --auto-attach
then
    echo "SUCCESS: System registered and entitlements attached."
else
    echo "ERROR: Subscription registration failed."
    exit 1
fi


echo "=== 2. Installing System Prerequisites, Compilers, & Python 3.9 ==="
dnf clean all

dnf install python39 python39-pip git gcc libssh-devel -y

echo "=== 3. Creating Global Python 3.9 Virtual Environment ==="

rm -rf ~/.automation/venv
mkdir -p ~/.automation


python3.9 -m venv ~/.automation/venv
source ~/.automation/venv/bin/activate

echo "=== 4. Upgrading Pip & Installing Core Python Libraries ==="
pip install --upgrade pip
pip install ansible paramiko secure-cookie ansible-pylibssh

echo "=== 5. Installing Cisco IOS Core Automation Collection ==="
ansible-galaxy collection install cisco.ios

echo "=== 6. Configuring Shell Auto-Activation ==="
if ! grep -q "source ~/.automation/venv/bin/activate" ~/.bashrc; then
    echo "source ~/.automation/venv/bin/activate" >> ~/.bashrc
fi

echo "===================================================================="
echo " SYSTEM READY: Registered, Python 3.9 active, Ansible/Cisco installed."
echo " Native libssh acceleration (ansible-pylibssh) is compiled and ready."
echo " You can now clone your project repositories anywhere on this node."
echo " Run: 'source ~/.automation/venv/bin/activate' to start immediately."
echo "===================================================================="
