FROM docker.io/library/debian:bookworm-slim

# Аргументы сборки
ARG JITSI_RELEASE=stable

# Переменные окружения
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Устанавливаем зависимости (без apt-dpkg-wrap) и определяем архитектуру
RUN dpkgArch="$(dpkg --print-architecture)" && \
    case "${dpkgArch##*-}" in \
        "amd64") TPL_ARCH=amd64; S6_ARCH=amd64 ;; \
        "arm64") TPL_ARCH=arm64; S6_ARCH=aarch64 ;; \
        *) echo "unsupported architecture"; exit 1 ;; \
    esac && \
    apt-get update && \
    apt-get install -y \
        apt-transport-https \
        apt-utils \
        ca-certificates \
        gnupg \
        wget \
        curl \
        openssh-client \
        lsb-release \
        make \
        unzip \
        nginx-extras \
        socat \
        cron \
        dnsutils \
        jq \
        procps \
        vim \
        iputils-ping \
        net-tools && \
    rm -rf /var/lib/apt/lists/*  # Очистка кеша APT

# Добавляем acme.sh
ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt

# 📌 **Загружаем готовую сборку**
COPY docker_build.tar.gz /tmp/docker_build.tar.gz

# 📌 **Распаковываем в нужную директорию**
RUN mkdir -p /usr/share/jitsi-meet && \
    tar -xzf /tmp/docker_build.tar.gz -C /usr/share/jitsi-meet && \
    rm /tmp/docker_build.tar.gz

# Устанавливаем tpl
RUN wget -qO /usr/bin/tpl "https://github.com/jitsi/tpl/releases/download/v1.4.0/tpl-linux-${TPL_ARCH}" && \
    chmod +x /usr/bin/tpl

# Устанавливаем S6 overlay
RUN wget -qO /tmp/s6.tar.gz "https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-${S6_ARCH}.tar.gz" && \
    mkdir /tmp/s6 && \
    tar xfz /tmp/s6.tar.gz -C /tmp/s6 && \
    tar hxfz /tmp/s6.tar.gz -C / && \
    rm -f /usr/bin/execlineb && \
    cp /tmp/s6/bin/execlineb /usr/bin/ && \
    rm -rf /tmp/s6*

# 📌 **Настройки репозиториев Jitsi (если они еще нужны)**
RUN wget -qO - "https://download.jitsi.org/jitsi-key.gpg.key" | gpg --dearmour > /etc/apt/trusted.gpg.d/jitsi.gpg && \
    echo "deb https://download.jitsi.org $JITSI_RELEASE/" > /etc/apt/sources.list.d/jitsi.list && \
    echo "deb http://ftp.debian.org/debian bookworm-backports main" > /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    rm -rf /var/lib/apt/lists/*

# Открываем порты
EXPOSE 80 443

# Определяем точки монтирования
VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

# Указываем точку входа
ENTRYPOINT [ "/init" ]
