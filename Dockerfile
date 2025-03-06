# Используем официальный образ Jitsi
FROM jitsi/web:${JITSI_IMAGE_VERSION:-unstable}

# Переопределяем репозиторий Jitsi Meet на ваш форк
RUN rm -rf /usr/share/jitsi-meet && \
    git clone ${JITSI_GIT_REPO} /usr/share/jitsi-meet && \
    cd /usr/share/jitsi-meet && git checkout ${JITSI_BRANCH}

# Дополнительные шаги могут быть добавлены здесь, если нужно
