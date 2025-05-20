# Semak keperluan asas
command -v docker >/dev/null || { echo "Docker tidak dijumpai."; exit 1; }
command -v docker-compose >/dev/null || { echo "Docker Compose tidak dijumpai."; exit 1; }

# Masuk ke direktori kelassir
cd kelassir

# Semak jika Laravel sudah wujud
if [ -d "lara/app/vendor" ]; then
  echo "Laravel sudah wujud. Langkau create-project."
else
  echo "Menjana projek Laravel..."
  sudo docker run --rm -v $(pwd)/lara/app:/app composer create-project --prefer-dist laravel/laravel=11.* /app
fi

# Jalankan docker-compose
sudo docker-compose up -d

# Tunggu Laravel container siap
echo "Menunggu Laravel container untuk sedia..."
while ! sudo docker exec kelassir_lara_app php -r "echo 'ready';" 2>/dev/null; do
  sleep 1
done
echo " ..... finished."

# Beri permission sementara untuk development
sudo chmod -R 777 lara/app/bootstrap
sudo chmod -R 777 lara/app/storage
sudo chmod 777 lara/app/.env

# Run key:generate & key:migration
echo "Finale..."
#sudo docker-compose exec lara-app bash -c "cp .env-kelassir .env; php artisan key:generate; php artisan migrate"
