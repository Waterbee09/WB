
if [ $? -ne 0 ]; then
  echo "การดาวน์โหลดไฟล์ติดตั้งล้มเหลว" >&2
  exit 1
fi
sleep 10  # รอ 10 วินาที

# 2. แสดงรายการไฟล์ในไดเรกทอรีปัจจุบัน
echo "แสดงรายการไฟล์ในไดเรกทอรีปัจจุบัน:"
ls
sleep 10  # รอ 10 วินาที

# 3. เปลี่ยนสิทธิ์ของไฟล์ติดตั้งเป็น 777
chmod 777 falcon-sensor_7.14.0-16703_amd64.deb
sleep 10  # รอ 10 วินาที

# 4. แสดงรายการไฟล์ในไดเรกทอรีปัจจุบันอีกครั้ง
echo "แสดงรายการไฟล์หลังจากเปลี่ยนสิทธิ์:"
ls
sleep 10  # รอ 10 วินาที

# 5. ติดตั้งแพ็กเกจ Falcon Sensor
echo "กำลังติดตั้ง Falcon Sensor..."
dpkg -i falcon-sensor_7.14.0-16703_amd64.deb
if [ $? -ne 0 ]; then
  echo "การติดตั้งล้มเหลว หรืออาจมีปัญหาการขึ้นทะเบียนแพ็กเกจ" >&2
  echo "กำลังติดตั้ง dependencies ที่ขาดหายไป..."
  apt-get -f install -y
fi
sleep 10  # รอ 10 วินาที

# 6. ตั้งค่า CID (Customer ID) สำหรับ Falcon Sensor
echo "กำลังตั้งค่า CID..."
/opt/CrowdStrike/falconctl -s --cid=00F79DE8BE94463D8482591A1A4B5AF2-85
sleep 10  # รอ 10 วินาที


sleep 10  # รอ 10 วินาที
