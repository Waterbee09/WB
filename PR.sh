#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root using sudo."
  exit 1
fi

# Update the system and install traceroute
echo "Updating the system and installing traceroute..."
apt update -y
apt install -y traceroute

# Stop the UFW service
echo "Stopping the UFW service..."
systemctl stop ufw

# Download Zabbix Repository for Ubuntu 22.04
ZABBIX_DEB="zabbix-release_7.0-2+ubuntu22.04_all.deb"
ZABBIX_URL="https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/${ZABBIX_DEB}"

echo "Downloading Zabbix repository from ${ZABBIX_URL}..."
wget -O /tmp/${ZABBIX_DEB} ${ZABBIX_URL}

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Failed to download Zabbix repository!"
  exit 1
fi

# Install Zabbix Repository
echo "Installing Zabbix repository..."
dpkg -i /tmp/${ZABBIX_DEB}

# Update apt after installing the new repository
echo "Updating apt after installing Zabbix repository..."
apt update -y

# Install MySQL Server
echo "Installing MySQL Server..."
apt install -y mysql-server

# Wait for the MySQL service to start
echo "Waiting for MySQL service to start..."
sleep 5

# Configure the database and user for Zabbix Proxy
echo "Configuring the Zabbix Proxy database..."

# Set the password for the zabbix user
ZABBIX_DB_PASSWORD="4rFvbgt%"

mysql -uroot <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS zabbix_proxy CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER IF NOT EXISTS 'zabbix'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON zabbix_proxy.* TO 'zabbix'@'localhost';
ALTER USER 'zabbix'@'localhost' IDENTIFIED BY '${ZABBIX_DB_PASSWORD}';
SET GLOBAL log_bin_trust_function_creators = 1;
MYSQL_SCRIPT

# Check if the MySQL commands were successful
if [ $? -ne 0 ]; then
  echo "Failed to configure the MySQL database!"
  exit 1
fi

# Import the database structure for Zabbix Proxy
echo "Importing the database structure for Zabbix Proxy..."
cat /usr/share/zabbix-sql-scripts/mysql/proxy.sql | mysql --default-character-set=utf8mb4 -uzabbix -p${ZABBIX_DB_PASSWORD} zabbix_proxy

if [ $? -ne 0 ]; then
  echo "Failed to import proxy.sql!"
  exit 1
fi

# Install Zabbix Proxy and SQL scripts
echo "Installing Zabbix Proxy and SQL scripts..."
apt install -y zabbix-proxy-mysql zabbix-sql-scripts

# Adjust the MySQL configuration
echo "Adjusting the MySQL configuration..."
mysql -uroot <<MYSQL_SCRIPT
SET GLOBAL log_bin_trust_function_creators = 0;
MYSQL_SCRIPT

if [ $? -ne 0 ]; then
  echo "Failed to adjust the MySQL configuration!"
  exit 1
fi

# Display the status of important services
echo "Checking the status of MySQL and Zabbix Proxy services..."
systemctl status mysql | grep "active (running)"
systemctl status zabbix-proxy | grep "active (running)"

echo "Installation and configuration completed successfully!"
