ARG JITSI_GIT_REPO
ARG JITSI_BRANCH

FROM jitsi/base:stable

LABEL org.opencontainers.image.source="https://github.com/sg12/jitsi-meet"

# Переменная для корректной обработки сбоев при старте контейнера
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

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
        jq \
        vim \
        iputils-ping \
        net-tools

# Устанавливаем s6-overlay (если он нужен)
RUN wget -qO - https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz | tar xfz - -C /

# Устанавливаем frep (если он нужен)
RUN wget -qO /usr/bin/frep https://github.com/subchen/frep/releases/download/v1.3.11/frep-1.3.11-linux-amd64 && chmod +x /usr/bin/frep

# Проверяем, существует ли папка, и очищаем её перед клонированием
RUN if [ -d "/usr/share/jitsi-meet" ]; then rm -rf /usr/share/jitsi-meet; fi && \
    git clone --depth 1 -b "${JITSI_BRANCH:-develop}" "${JITSI_GIT_REPO:-https://github.com/sg12/jitsi-meet.git}" /usr/share/jitsi-meet

# Удаляем кеши, чтобы уменьшить размер образа
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Добавляем скрипт для автоматической выдачи сертификатов
ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt
RUN chmod +x /opt/acme.sh

# Переносим дефолтные настройки Jitsi
RUN mv /usr/share/jitsi-meet/interface_config.js /defaults && \
    rm -f /etc/nginx/conf.d/default.conf

# Устанавливаем jitsi-meet-web-config (если он необходим)
RUN apt-dpkg-wrap apt-get -d install -y jitsi-meet-web-config && \
    dpkg -x /var/cache/apt/archives/jitsi-meet-web-config*.deb /tmp/pkg && \
    mv /tmp/pkg/usr/share/jitsi-meet-web-config/config.js /defaults && \
    rm -rf /tmp/pkg /var/cache/apt

# Открываем корректные порты взаимодействия
EXPOSE 80 443 8443 8000

VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

# Стартовый процесс
ENTRYPOINT ["/init"]
