#!/bin/bash

# Очікуємо доступності MySQL
echo "Waiting for MySQL to be ready..."
while ! nc -z mysql 3306; do
  sleep 4
done
echo "MySQL is ready! Starting application..."

# Запускаємо застосунок
poetry run python app.py
