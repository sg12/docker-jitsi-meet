ARG JITSI_GIT_REPO
ARG JITSI_BRANCH

FROM jitsi/base:stable

LABEL org.opencontainers.image.source="https://github.com/sg12/jitsi-meet"

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
        git \
        apt-transport-https \
        apt-utils \
        ca-certificates \
        gnupg \
        wget \
        dnsutils \
        cron \
        nginx-extras \
        jitsi-meet-web \
        socat \
        curl \
        jq

# Проверяем, существует ли папка, и очищаем её перед клонированием
RUN if [ -d "/usr/share/jitsi-meet" ]; then rm -rf /usr/share/jitsi-meet; fi && \
    git clone --depth 1 -b "${JITSI_BRANCH:-develop}" "${JITSI_GIT_REPO:-https://github.com/sg12/jitsi-meet.git}" /usr/share/jitsi-meet

# Удаляем лишние файлы, чтобы уменьшить размер образа
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Добавляем скрипт для автоматической выдачи сертификатов
ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt
RUN chmod +x /opt/acme.sh

# Переносим дефолтные настройки Jitsi
RUN mv /usr/share/jitsi-meet/interface_config.js /defaults && \
    rm -f /etc/nginx/conf.d/default.conf

# Открываем порты взаимодействия
EXPOSE 8443 8000

VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

# Запуск nginx
CMD ["nginx", "-g", "daemon off;"]
