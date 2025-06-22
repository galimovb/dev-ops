# 1. Базовый образ Ubuntu
FROM ubuntu:22.04

# 2. Автор образа
MAINTAINER Galimov Bulat <galimovbulat66@gmail.com>

# 3. Установка Nginx и PostgreSQL
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx postgresql postgresql-contrib && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 4. Рабочая директория
WORKDIR /app

# 5. Копирование конфигурации Nginx
COPY /nginx/nginx.conf /etc/nginx/nginx.conf

# 6. Копирование веб-ресурсов
ADD /site/index.html /var/www/html/

# 7. Объявление тома для данных PostgreSQL
VOLUME /var/lib/postgresql/data

# 8. Создание пользователя для приложения
RUN useradd -ms /bin/bash pguser

# 9. Переключение на непривилегированного пользователя
USER pguser

# 10. Открытие портов
EXPOSE 80 5432

# 11. Команда запуска сервисов
CMD service postgresql start && nginx -g 'daemon off;'
