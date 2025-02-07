ARG JITSI_GIT_REPO
ARG JITSI_BRANCH

FROM jitsi/base:stable

SHELL ["/usr/bin/sh", "-c"]

LABEL org.opencontainers.image.source="https://github.com/sg12/jitsi-meet"

# ✅ Устанавливаем GPG перед загрузкой ключей
RUN apt-get update && apt-get install -y gnupg wget ca-certificates

# ✅ Загружаем ключи и проверяем их
RUN mkdir -p /usr/share/keyrings && \
    wget -qO /tmp/debian-key.asc https://ftp-master.debian.org/keys/archive-key-12.asc && \
    if [ ! -s /tmp/debian-key.asc ]; then echo "Ошибка загрузки archive-key-12.asc"; exit 1; fi && \
    gpg --batch --yes --dearmor -o /usr/share/keyrings/debian-archive-keyring.gpg /tmp/debian-key.asc && \
    wget -qO /tmp/security-key.asc https://ftp-master.debian.org/keys/archive-key-12-security.asc && \
    if [ ! -s /tmp/security-key.asc ]; then echo "Ошибка загрузки archive-key-12-security.asc"; exit 1; fi && \
    gpg --batch --yes --dearmor -o /usr/share/keyrings/debian-archive-keyring-security.gpg /tmp/security-key.asc && \
    wget -qO /tmp/jitsi-key.asc https://download.jitsi.org/jitsi-key.gpg.key && \
    if [ ! -s /tmp/jitsi-key.asc ]; then echo "Ошибка загрузки jitsi-key.gpg.key"; exit 1; fi && \
    gpg --batch --yes --dearmor -o /usr/share/keyrings/jitsi-keyring.gpg /tmp/jitsi-key.asc

# ✅ Обновляем `sources.list` с правильными `signed-by`
RUN echo "deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian bookworm main" > /etc/apt/sources.list.d/debian.list
RUN echo "deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian-security bookworm-security main" > /etc/apt/sources.list.d/debian-security.list
RUN echo "deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://ftp.debian.org/debian bookworm-backports main" > /etc/apt/sources.list.d/debian-backports.list
RUN echo "deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/" > /etc/apt/sources.list.d/jitsi.list

# ✅ Устанавливаем базовые пакеты
RUN apt-get update --allow-releaseinfo-change && \
    apt-get install -y --allow-change-held-packages apt-transport-https ca-certificates

RUN apt-get install -y \
        git \
        apt-utils \
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

# ✅ Устанавливаем s6-overlay
RUN wget -qO - https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz | tar xfz - -C /

# ✅ Устанавливаем frep
RUN wget -qO /usr/bin/frep https://github.com/subchen/frep/releases/download/v1.3.11/frep-1.3.11-linux-amd64 && chmod +x /usr/bin/frep

# ✅ Проверяем, существует ли папка, и очищаем её перед клонированием
RUN if [ -d "/usr/share/jitsi-meet" ]; then rm -rf /usr/share/jitsi-meet; fi && \
    git clone --depth 1 -b "${JITSI_BRANCH:-develop}" "${JITSI_GIT_REPO:-https://github.com/sg12/jitsi-meet.git}" /usr/share/jitsi-meet

# ✅ Удаляем кеши
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ✅ Добавляем acme.sh
ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt
RUN chmod +x /opt/acme.sh

# ✅ Переносим дефолтные настройки Jitsi
RUN mv /usr/share/jitsi-meet/interface_config.js /defaults && \
    rm -f /etc/nginx/conf.d/default.conf

# ✅ Устанавливаем `jitsi-meet-web-config`
RUN apt-get update && \
    apt-get install -y --download-only jitsi-meet-web-config && \
    dpkg -x /var/cache/apt/archives/jitsi-meet-web-config*.deb /tmp/pkg && \
    mv /tmp/pkg/usr/share/jitsi-meet-web-config/config.js /defaults && \
    rm -rf /tmp/pkg /var/cache/apt

# ✅ Открываем нужные порты
EXPOSE 80 443 8443 8000

VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

ENTRYPOINT ["/init"]
