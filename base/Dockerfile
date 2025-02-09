FROM docker.io/library/debian:bookworm-slim

ARG JITSI_RELEASE=stable
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

COPY rootfs /

RUN \
    dpkgArch="$(dpkg --print-architecture)" && \
    case "${dpkgArch##*-}" in \
        "amd64") TPL_ARCH=amd64; S6_ARCH=amd64 ;; \
        "arm64") TPL_ARCH=arm64; S6_ARCH=aarch64 ;; \
        *) echo "unsupported architecture"; exit 1 ;; \
    esac && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y apt-transport-https apt-utils ca-certificates gnupg wget curl && \
    wget -qO /usr/bin/tpl https://github.com/jitsi/tpl/releases/download/v1.4.0/tpl-linux-${TPL_ARCH} && \
    # Workaround S6 bug when /bin is a symlink
    wget -qO /tmp/s6.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-${S6_ARCH}.tar.gz && \
    mkdir /tmp/s6 && \
    tar xfz /tmp/s6.tar.gz -C /tmp/s6 && \
    tar hxfz /tmp/s6.tar.gz -C / && \
    rm -f /usr/bin/execlineb && \
    cp /tmp/s6/bin/execlineb /usr/bin/ && \
    rm -rf /tmp/s6* && \
    wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | gpg --dearmour > /etc/apt/trusted.gpg.d/jitsi.gpg && \
    echo "deb http://ftp.debian.org/debian bookworm-backports main" > /etc/apt/sources.list.d/backports.list && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get dist-upgrade -y && \
    apt-cleanup && \
    chmod +x /usr/bin/tpl

RUN [ "$JITSI_RELEASE" = "unstable" ] && \
    apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y jq procps curl vim iputils-ping net-tools && \
    apt-cleanup || \
    true

# ❌ Удаляем официальный репозиторий Jitsi
RUN rm -f /etc/apt/sources.list.d/jitsi.list

# ✅ Обновляем список пакетов перед установкой `git`, `npm`, `make`
RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y git curl ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-dpkg-wrap apt-get install -y nodejs make && \
    rm -rf /var/lib/apt/lists/*

# 📌 Клонируем ваш форк Jitsi Meet
ARG JITSI_GIT_REPO=https://github.com/sg12/jitsi-meet.git
ARG JITSI_BRANCH=develop

RUN git config --global http.postBuffer 524288000
RUN git config --global core.compression 0

RUN git clone --branch ${JITSI_BRANCH} ${JITSI_GIT_REPO} /usr/src/jitsi-meet && \
    cd /usr/src/jitsi-meet && \
    npm install && \
    make

# 📌 Копируем собранный Jitsi Meet в нужное место
RUN cp -r /usr/src/jitsi-meet /usr/share/jitsi-meet

# 📌 Очищаем ненужные файлы
RUN rm -rf /usr/src/jitsi-meet/.git /usr/src/jitsi-meet/node_modules

ENTRYPOINT [ "/init" ]
