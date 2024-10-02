#!/bin/bash

# Exit the script if any command returns a non-true value
set -e

# Uninstall Zabbix Proxy
echo "Stopping and uninstalling Zabbix Proxy..."
if systemctl is-active --quiet zabbix-proxy; then
    sudo systemctl stop zabbix-proxy
fi
sudo systemctl disable zabbix-proxy
sudo apt-get remove --purge -y zabbix-proxy
sudo rm -rf /etc/zabbix/
sudo rm -rf /var/log/zabbix/
sudo rm -rf /var/lib/zabbix/
sudo apt-get autoremove -y
sudo apt-get clean

# Uninstall MySQL
echo "Stopping and uninstalling MySQL..."
if systemctl is-active --quiet mysql; then
    sudo systemctl stop mysql
fi
sudo systemctl disable mysql
sudo apt-get remove --purge -y mysql-server mysql-client mysql-common
sudo rm -rf /etc/mysql/
sudo rm -rf /var/lib/mysql/
sudo rm -rf /var/log/mysql/
sudo apt-get autoremove -y
sudo apt-get clean

# Update and upgrade system
echo "Updating and upgrading system..."
sudo apt-get update -qq
sudo apt-get upgrade -y -qq

echo "Uninstallation complete and system updated."
