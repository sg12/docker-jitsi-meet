#!/bin/bash

# Скрипт для запуска Jitsi Meet с локальной версией репозитория

if [ -z "$1" ]; then
    echo "Использование: $0 <путь_к_локальному_репозиторию_jitsi_meet>"
    echo "Пример: $0 /path/to/your/jitsi-meet"
    exit 1
fi

LOCAL_JITSI_PATH="$1"

if [ ! -d "$LOCAL_JITSI_PATH" ]; then
    echo "Ошибка: Каталог $LOCAL_JITSI_PATH не существует"
    exit 1
fi

if [ ! -f "$LOCAL_JITSI_PATH/interface_config.js" ] && [ ! -f "$LOCAL_JITSI_PATH/config.js" ]; then
    echo "Предупреждение: Не найдены основные файлы Jitsi Meet в $LOCAL_JITSI_PATH"
    echo "Убедитесь, что вы указали правильный путь к репозиторию jitsi-meet"
fi

echo "Запускаем сборку с локальной версией Jitsi Meet из: $LOCAL_JITSI_PATH"

# Создаем временный маркер локальной сборки
MARKER_FILE="$LOCAL_JITSI_PATH/LOCAL_BUILD_MARKER"
if [ ! -f "$MARKER_FILE" ]; then
    DATE=$(date)
    echo "Локальная сборка Jitsi Meet" > "$MARKER_FILE"
    echo "Дата создания: $DATE" >> "$MARKER_FILE"
    echo "Путь к исходному коду: $LOCAL_JITSI_PATH" >> "$MARKER_FILE"
fi

# Запускаем docker-compose с указанием локального пути
LOCAL_JITSI_PATH="$LOCAL_JITSI_PATH" JITSI_GIT_REPO="" JITSI_BRANCH="" docker-compose up --build