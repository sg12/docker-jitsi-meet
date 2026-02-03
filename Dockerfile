# Используем официальный образ Jitsi как базовый
FROM jitsi/web:${JITSI_IMAGE_VERSION:-unstable}

# Аргументы для возможности использования локального репозитория
ARG LOCAL_JITSI_PATH
ARG JITSI_GIT_REPO=https://github.com/sg12/jitsi-meet.git
ARG JITSI_BRANCH=develop

# Удаляем официальную версию и клонируем нужный репозиторий
# Если указан LOCAL_JITSI_PATH, то копируем из локального каталога
RUN if [ -n "$LOCAL_JITSI_PATH" ] ; then \
        echo "Используем локальную версию Jitsi Meet из $LOCAL_JITSI_PATH" && \
        rm -rf /usr/share/jitsi-meet && \
        cp -r $LOCAL_JITSI_PATH /usr/share/jitsi-meet ; \
    else \
        echo "Клонируем Jitsi Meet из $JITSI_GIT_REPO, ветка $JITSI_BRANCH" && \
        rm -rf /usr/share/jitsi-meet && \
        git clone --depth 1 -b "$JITSI_BRANCH" "$JITSI_GIT_REPO" /usr/share/jitsi-meet ; \
    fi

# Дополнительные шаги могут быть добавлены здесь, если нужно
