#!/bin/bash

# Скрипт для проверки, что используется локальная версия Jitsi Meet

echo "Проверяем, какая версия Jitsi Meet используется в контейнере..."

# Получаем ID запущенного контейнера web
CONTAINER_ID=$(docker ps -q -f name=web)

if [ -z "$CONTAINER_ID" ]; then
    echo "Контейнер web не запущен. Попробуйте сначала запустить 'docker-compose up -d'"
    exit 1
fi

echo "Контейнер web запущен с ID: $CONTAINER_ID"

# Проверяем наличие маркера локальной сборки
if docker exec $CONTAINER_ID test -f /usr/share/jitsi-meet/LOCAL_BUILD_MARKER; then
    echo "✓ Обнаружен маркер локальной сборки: /usr/share/jitsi-meet/LOCAL_BUILD_MARKER"
    echo "✓ Используется локальная версия Jitsi Meet"
    
    # Показываем содержимое маркера
    echo "Содержимое маркера:"
    docker exec $CONTAINER_ID cat /usr/share/jitsi-meet/LOCAL_BUILD_MARKER
else
    echo "✗ Маркер локальной сборки не найден"
    echo "Возможно, используется удаленный репозиторий"
fi

# Проверяем git информацию в контейнере
echo ""
echo "Проверяем информацию о репозитории в контейнере..."
if docker exec $CONTAINER_ID test -d /usr/share/jitsi-meet/.git; then
    echo "Найден .git каталог в контейнере"
    echo "Последний коммит:"
    docker exec $CONTAINER_ID sh -c "cd /usr/share/jitsi-meet && git log -1 --oneline"
else
    echo "Каталог .git не найден в контейнере (это нормально для production сборки)"
fi