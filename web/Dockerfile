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

# Устанавливаем зависимости
RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y \
        apt-transport-https \
        apt-utils \
        ca-certificates \
        gnupg \
        wget \
        curl \
        nginx-extras \
        socat \
        cron \
        dnsutils \
        unzip && \
    apt-cleanup

# Добавляем acme.sh
ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt

# 📌 **Загружаем архив сборки (замени путь, если нужно)**
COPY docker_build.tar.gz /tmp/docker_build.tar.gz

# 📌 **Распаковываем**
RUN mkdir -p /usr/share/jitsi-meet && \
    tar -xzf /tmp/docker_build.tar.gz -C /usr/share/jitsi-meet && \
    rm /tmp/docker_build.tar.gz

# Устанавливаем tpl (если нужно)
RUN wget -qO /usr/bin/tpl https://github.com/jitsi/tpl/releases/download/v1.4.0/tpl-linux-amd64 && \
    chmod +x /usr/bin/tpl

# Открываем порты
EXPOSE 80 443

# Определяем точки монтирования
VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

# Указываем точку входа
ENTRYPOINT [ "/init" ]

