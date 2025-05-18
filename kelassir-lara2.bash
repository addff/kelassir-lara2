#!/bin/bash

# Semak keperluan asas
command -v docker >/dev/null || { echo "Docker tidak dijumpai."; exit 1; }
command -v docker-compose >/dev/null || { echo "Docker Compose tidak dijumpai."; exit 1; }

# Semak jika Laravel sudah wujud
if [ -d "kelassir/lara/src/vendor" ]; then
  echo "Laravel sudah wujud. Langkau create-project."
else
  echo "Menjana projek Laravel..."
  docker run --rm -v $(pwd)/kelassir/lara/src:/app composer create-project --prefer-dist laravel/laravel=11.* /app
fi

# Masuk ke direktori kelassir
cd kelassir

# Jalankan docker-compose
docker-compose up -d

# Tunggu Laravel container siap
echo "Menunggu Laravel container untuk sedia..."
while ! docker exec kelassir-lara-app php -r "echo 'ready';" 2>/dev/null; do
  sleep 1
done

# Jana APP_KEY
echo "Menjana APP_KEY..."
docker exec kelassir-lara-app php artisan key:generate

# Jalankan migrasi
echo "Menjalankan migrasi..."
docker exec kelassir-lara-app php artisan migrate
