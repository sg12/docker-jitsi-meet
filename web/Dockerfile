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

# Переменные окружения
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Устанавливаем зависимости (без apt-dpkg-wrap)
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
        dnsutils && \
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
RUN wget -qO /usr/bin/tpl https://github.com/jitsi/tpl/releases/download/v1.4.0/tpl-linux-${TPL_ARCH} && \
    chmod +x /usr/bin/tpl

# Открываем порты
EXPOSE 80 443

# Определяем точки монтирования
VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

# Указываем точку входа
ENTRYPOINT [ "/init" ]
