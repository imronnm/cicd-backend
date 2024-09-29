# Stage pertama untuk menginstal dependensi
FROM node:14-alpine
WORKDIR /app

# Menyalin file package.json dan menginstal dependensi
COPY package*.json ./
RUN npm install

# Menyalin semua file ke dalam kontainer
COPY . .

# Menginstal PM2 secara global
RUN npm install pm2 -g

# Menyalin file konfigurasi PM2
COPY ecosystem.config.js ./

# Menjalankan aplikasi menggunakan PM2
CMD ["pm2-runtime", "ecosystem.config.js"]
