#!/bin/bash

# Uninstall Zabbix Proxy
echo "Stopping and uninstalling Zabbix Proxy..."
sudo systemctl stop zabbix-proxy
sudo systemctl disable zabbix-proxy
sudo apt-get remove --purge -y zabbix-proxy
sudo rm -rf /etc/zabbix/
sudo rm -rf /var/log/zabbix/
sudo rm -rf /var/lib/zabbix/
sudo apt-get autoremove -y
sudo apt-get clean

# Uninstall MySQL
echo "Stopping and uninstalling MySQL..."
sudo systemctl stop mysql
sudo systemctl disable mysql
sudo apt-get remove --purge -y mysql-server mysql-client mysql-common
sudo rm -rf /etc/mysql/
sudo rm -rf /var/lib/mysql/
sudo rm -rf /var/log/mysql/
sudo apt-get autoremove -y
sudo apt-get clean

# Update and upgrade system
echo "Updating and upgrading system..."
sudo apt-get update
sudo apt-get upgrade -y

echo "Uninstallation complete and system updated."
