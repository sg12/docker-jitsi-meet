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

# Проверка аргументов перед клонированием
RUN echo "Cloning from $JITSI_GIT_REPO, branch $JITSI_BRANCH"

RUN git clone --depth 1 -b "${JITSI_BRANCH:-develop}" "${JITSI_GIT_REPO:-https://github.com/sg12/jitsi-meet.git}" /usr/share/jitsi-meet || \
    (echo "Ошибка: Репозиторий не найден или неверный branch"; exit 1)

# Удаляем лишние файлы, чтобы уменьшить размер образа
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Добавляем скрипт для автоматической выдачи сертификатов
ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt
RUN chmod +x /opt/acme.sh

# Переносим дефолтные настройки Jitsi
RUN mv /usr/share/jitsi-meet/interface_config.js /defaults && \
    rm -f /etc/nginx/conf.d/default.conf

# Копируем кастомный конфиг nginx в контейнер
COPY web/rootfs/etc/nginx/sites-available/default /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Открываем порты взаимодействия
EXPOSE 8443 8000

VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

# Запуск nginx
CMD ["nginx", "-g", "daemon off;"]
