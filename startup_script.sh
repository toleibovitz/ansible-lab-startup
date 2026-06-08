#!/bin/bash

set -euo pipefail

echo "===================================================================="
echo " RHEL Automation Node Bootstrap"
echo "===================================================================="

#

# Ensure we are root

#

if [[ $EUID -ne 0 ]]; then
echo "ERROR: This script must be run as root."
echo "Try: sudo bash startup_script.sh"
exit 1
fi

#

# Red Hat credentials

#

RH_USER="${RH_USER:-}"
RH_PASS="${RH_PASS:-}"

echo
echo "=== 1. Red Hat Subscription Registration ==="

if subscription-manager identity >/dev/null 2>&1; then
echo "System already registered."
else


if [[ -z "$RH_USER" ]]; then
    read -p "Enter Red Hat Developer Username: " RH_USER
fi

if [[ -z "$RH_PASS" ]]; then
    read -s -p "Enter Red Hat Developer Password: " RH_PASS
    echo
fi

echo "Registering system..."

subscription-manager register \
    --username "$RH_USER" \
    --password "$RH_PASS" \
    --auto-attach

echo "Registration successful."


fi

echo
echo "=== 2. Updating Package Metadata ==="

dnf clean all
dnf makecache

echo
echo "=== 3. Installing Packages ==="

dnf install -y 
python39 
python39-pip 
python39-devel 
git 
gcc 
libssh-devel

echo
echo "=== 4. Creating Automation Virtual Environment ==="

mkdir -p ~/.automation

if [[ -d ~/.automation/venv ]]; then
rm -rf ~/.automation/venv
fi

python3.9 -m venv ~/.automation/venv

source ~/.automation/venv/bin/activate

echo
echo "=== 5. Upgrading Pip ==="

python -m pip install --upgrade pip

echo
echo "=== 6. Installing Python Libraries ==="

pip install 
ansible 
paramiko 
secure-cookie 
ansible-pylibssh

echo
echo "=== 7. Installing Cisco Collection ==="

ansible-galaxy collection install cisco.ios

echo
echo "=== 8. Configuring Auto-Activation ==="

if ! grep -q ".automation/venv/bin/activate" ~/.bashrc; then
echo "" >> ~/.bashrc
echo "source ~/.automation/venv/bin/activate" >> ~/.bashrc
fi

echo
echo "===================================================================="
echo " BOOTSTRAP COMPLETE"
echo "===================================================================="
echo " Python Virtual Environment:"
echo "   ~/.automation/venv"
echo
echo " Activate manually:"
echo "   source ~/.automation/venv/bin/activate"
echo
echo " Installed:"
echo "   - Python 3.9"
echo "   - Ansible"
echo "   - Paramiko"
echo "   - ansible-pylibssh"
echo "   - Cisco IOS Collection"
echo "===================================================================="

