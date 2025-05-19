#!/bin/bash

# Semak keperluan asas
command -v docker >/dev/null || { echo "Docker tidak dijumpai."; exit 1; }
command -v docker-compose >/dev/null || { echo "Docker Compose tidak dijumpai."; exit 1; }

# Masuk ke direktori kelassir
cd kelassir

# Jalankan docker-compose
docker-compose up -d

# Tunggu Laravel container siap
echo "Menunggu Laravel container untuk sedia..."
while ! docker exec kelassir_lara_app php -r "echo 'ready';" 2>/dev/null; do
  sleep 1
done

# Run composer di dalam container
echo "Menjalankan Composer di dalam container"
docker-compose exec kelassir-lara-app bash -c "rm -rf *; composer create-project laravel/laravel ."

