# ใช้ Nginx เป็น Base Image
FROM nginx:alpine

# คัดลอกไฟล์ HTML ไปยัง directory ของ Nginx
COPY wb.html /usr/share/nginx/html/index.html

# เปิดพอร์ต 80
EXPOSE 80

