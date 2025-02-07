ARG JITSI_GIT_REPO
ARG JITSI_BRANCH

FROM jitsi/base:stable

SHELL ["/usr/bin/sh", "-c"]

LABEL org.opencontainers.image.source="https://github.com/sg12/jitsi-meet"

# Исправляем отсутствие /bin/sh
RUN if [ ! -f "/bin/sh" ]; then ln -s /usr/bin/sh /bin/sh; fi

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# ✅ Удаляем дублирующиеся файлы перед настройкой репозиториев
RUN rm -f /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources

# ✅ Загружаем ключи Debian и Jitsi
RUN rm -rf /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d
RUN mkdir -p /usr/share/keyrings /etc/apt/keyrings
RUN wget -qO - https://ftp-master.debian.org/keys/release-12.asc | gpg --dearmor > /usr/share/keyrings/debian-archive-keyring.gpg
RUN wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | gpg --dearmor > /etc/apt/keyrings/jitsi.gpg

# ✅ Добавляем репозитории с `signed-by`
RUN echo "deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian bookworm main" > /etc/apt/sources.list.d/debian.list
RUN echo "deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian-security bookworm-security main" > /etc/apt/sources.list.d/debian-security.list
RUN echo "deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian bookworm-updates main" > /etc/apt/sources.list.d/debian-updates.list
RUN echo "deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://ftp.debian.org/debian bookworm-backports main" > /etc/apt/sources.list.d/debian-backports.list
RUN echo "deb [signed-by=/etc/apt/keyrings/jitsi.gpg] https://download.jitsi.org stable/" > /etc/apt/sources.list.d/jitsi.list

# ✅ Обновляем пакеты без ошибок GPG
RUN apt-get update --allow-releaseinfo-change && apt-get dist-upgrade -y

RUN apt-get install -y \
        git \
        apt-transport-https \
        apt-utils \
        ca-certificates \
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

# Устанавливаем s6-overlay
RUN wget -qO - https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz | tar xfz - -C /

# Устанавливаем frep
RUN wget -qO /usr/bin/frep https://github.com/subchen/frep/releases/download/v1.3.11/frep-1.3.11-linux-amd64 && chmod +x /usr/bin/frep

# Проверяем, существует ли папка, и очищаем её перед клонированием
RUN if [ -d "/usr/share/jitsi-meet" ]; then rm -rf /usr/share/jitsi-meet; fi && \
    git clone --depth 1 -b "${JITSI_BRANCH:-develop}" "${JITSI_GIT_REPO:-https://github.com/sg12/jitsi-meet.git}" /usr/share/jitsi-meet

# Удаляем кеши
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Добавляем acme.sh
ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt
RUN chmod +x /opt/acme.sh

# Переносим дефолтные настройки Jitsi
RUN mv /usr/share/jitsi-meet/interface_config.js /defaults && \
    rm -f /etc/nginx/conf.d/default.conf

# ✅ Исправлено: убираем `apt-dpkg-wrap` и правим установку jitsi-meet-web-config
RUN apt-get update && \
    apt-get install -y --download-only jitsi-meet-web-config && \
    dpkg -x /var/cache/apt/archives/jitsi-meet-web-config*.deb /tmp/pkg && \
    mv /tmp/pkg/usr/share/jitsi-meet-web-config/config.js /defaults && \
    rm -rf /tmp/pkg /var/cache/apt

# Открываем нужные порты
EXPOSE 80 443 8443 8000

VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

ENTRYPOINT ["/init"]
