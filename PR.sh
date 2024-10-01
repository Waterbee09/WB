#!/bin/bash

# อัพเดตระบบและติดตั้ง traceroute
echo "กำลังติดตั้ง traceroute..."
apt update
apt install traceroute

# หยุดบริการ UFW
echo "กำลังหยุดบริการ UFW..."
systemctl stop ufw

# ดาวน์โหลดและติดตั้ง Zabbix Repository
echo "กำลังดาวน์โหลด Zabbix repository..."
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-2+ubuntu20.04_all.deb

echo "กำลังติดตั้ง Zabbix repository..."
dpkg -i zabbix-release_7.0-2+ubuntu20.04_all.deb

# อัพเดต apt หลังจากติดตั้ง repository ใหม่
echo "กำลังอัพเดต apt..."
apt update

# ติดตั้ง MySQL Server
echo "กำลังติดตั้ง MySQL Server..."
apt install -y mysql-server

# ตั้งค่าฐานข้อมูลและผู้ใช้สำหรับ Zabbix Proxy
echo "กำลังตั้งค่าฐานข้อมูล Zabbix Proxy..."
mysql <<EOF
CREATE DATABASE zabbix_proxy CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '4rFvbgt%';
GRANT ALL PRIVILEGES ON zabbix_proxy.* TO 'zabbix'@'localhost';
ALTER USER 'zabbix'@'localhost' IDENTIFIED BY '4rFvbgt%';
SET GLOBAL log_bin_trust_function_creators = 1;
EOF

# นำเข้าโครงสร้างฐานข้อมูลสำหรับ Zabbix Proxy
echo "กำลังนำเข้าโครงสร้างฐานข้อมูลสำหรับ Zabbix Proxy..."
cat /usr/share/zabbix-sql-scripts/mysql/proxy.sql | mysql --default-character-set=utf8mb4 -uzabbix -p4rFvbgt% zabbix_proxy

# ติดตั้ง Zabbix Proxy และสคริปต์ SQL
echo "กำลังติดตั้ง Zabbix Proxy และ SQL scripts..."
apt install -y zabbix-proxy-mysql zabbix-sql-scripts

# ปรับแต่งค่าคอนฟิก MySQL
echo "กำลังปรับแต่งค่าคอนฟิก MySQL..."
mysql <<EOF
SET GLOBAL log_bin_trust_function_creators = 0;
EOF

echo "การติดตั้งและตั้งค่าเสร็จสมบูรณ์แล้ว!"
