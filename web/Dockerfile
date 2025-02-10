#ARG JITSI_REPO=jitsi
#ARG BASE_TAG=latest
#FROM custom-jitsi-base

#LABEL org.opencontainers.image.title="Jitsi Meet"
#LABEL org.opencontainers.image.description="WebRTC compatible JavaScript application that uses Jitsi Videobridge to provide high quality, scalable video conferences."
#LABEL org.opencontainers.image.url="https://jitsi.org/jitsi-meet/"
#LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
#LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

#ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt
#COPY rootfs/ /

#RUN apt-dpkg-wrap apt-get update && \
#    apt-dpkg-wrap apt-get install -y dnsutils cron nginx-extras jitsi-meet-web socat curl jq && \
#    mv /usr/share/jitsi-meet/interface_config.js /defaults && \
#    rm -f /etc/nginx/conf.d/default.conf && \
#    apt-cleanup

#EXPOSE 80 443

#VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

FROM docker.io/library/debian:bookworm-slim

# Аргументы сборки
ARG JITSI_RELEASE=stable
ARG JITSI_GIT_REPO="https://github.com/sg12/jitsi-meet.git"
ARG JITSI_BRANCH=develop
ARG SSH_PRIVATE_KEY

# Переменные окружения
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Устанавливаем зависимости
RUN dpkgArch="$(dpkg --print-architecture)" && \
    case "${dpkgArch##*-}" in \
        "amd64") TPL_ARCH=amd64; S6_ARCH=amd64 ;; \
        "arm64") TPL_ARCH=arm64; S6_ARCH=aarch64 ;; \
        *) echo "unsupported architecture"; exit 1 ;; \
    esac && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
        apt-transport-https \
        apt-utils \
        ca-certificates \
        gnupg \
        wget \
        curl \
        git \
        openssh-client \
        lsb-release \
        make \
        unzip \
        nginx-extras \
        socat \
        cron \
        dnsutils && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-dpkg-wrap apt-get install -y nodejs && \
    npm --version

# Добавляем acme.sh
ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt

# Настроим Git, чтобы избежать проблем с загрузкой
RUN git config --global http.postBuffer 1048576000 && \
    git clone --branch ${JITSI_BRANCH} ${JITSI_GIT_REPO} /usr/src/jitsi-meet || { echo "Git clone failed"; exit 1; }

# Переходим в папку с кодом
WORKDIR /usr/src/jitsi-meet

# Устанавливаем зависимости и собираем фронтенд
RUN npm install && \
    make && \
    cp -r /usr/src/jitsi-meet /usr/share/jitsi-meet && \
    rm -rf /usr/src/jitsi-meet/.git && \
    rm -rf /usr/src/jitsi-meet/node_modules

# Устанавливаем tpl
RUN wget -qO /usr/bin/tpl https://github.com/jitsi/tpl/releases/download/v1.4.0/tpl-linux-${TPL_ARCH} && \
    wget -qO /tmp/s6.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-${S6_ARCH}.tar.gz && \
    mkdir /tmp/s6 && \
    tar xfz /tmp/s6.tar.gz -C /tmp/s6 && \
    tar hxfz /tmp/s6.tar.gz -C / && \
    rm -f /usr/bin/execlineb && \
    cp /tmp/s6/bin/execlineb /usr/bin/ && \
    rm -rf /tmp/s6*

# Добавляем репозитории Jitsi
RUN wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | gpg --dearmour > /etc/apt/trusted.gpg.d/jitsi.gpg && \
    echo "deb https://download.jitsi.org $JITSI_RELEASE/" > /etc/apt/sources.list.d/jitsi.list && \
    echo "deb http://ftp.debian.org/debian bookworm-backports main" > /etc/apt/sources.list.d/backports.list && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get dist-upgrade -y && \
    apt-cleanup

# Открываем порты
EXPOSE 80 443

# Определяем точки монтирования
VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

# Указываем точку входа
ENTRYPOINT [ "/init" ]

