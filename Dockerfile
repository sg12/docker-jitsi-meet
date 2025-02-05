# Используем официальный образ Jitsi
FROM jitsi/web:${JITSI_IMAGE_VERSION:-unstable}

# Удаляем старый репозиторий, выводим информацию для отладки
RUN echo "Удаляем старый репозиторий..." && \
    rm -rf /usr/share/jitsi-meet && \
    echo "Клонируем новый репозиторий..." && \
    git clone ${JITSI_GIT_REPO} /usr/share/jitsi-meet && \
    cd /usr/share/jitsi-meet && git checkout ${JITSI_BRANCH} && \
    echo "Репозиторий успешно клонирован и ветка переключена"

# Дополнительные шаги могут быть добавлены здесь, если нужно

