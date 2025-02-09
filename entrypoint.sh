#!/bin/sh
set -e

echo "🔄 [ENTRYPOINT] Генерация конфигов с помощью frep..."
/usr/bin/frep /config/nginx/meet.conf --overwrite /config/nginx/meet.conf
/usr/bin/frep /config/nginx/ssl.conf --overwrite /config/nginx/ssl.conf
/usr/bin/frep /etc/nginx/nginx.conf --overwrite /etc/nginx/nginx.conf

echo "✅ [ENTRYPOINT] Конфиги Nginx обновлены."

exec /init
