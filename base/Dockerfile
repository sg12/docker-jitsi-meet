FROM docker.io/library/debian:bookworm-slim

ARG JITSI_RELEASE=stable
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Устанавливаем зависимости
RUN \
    dpkgArch="$(dpkg --print-architecture)" && \
    case "${dpkgArch##*-}" in \
        "amd64") TPL_ARCH=amd64; S6_ARCH=amd64 ;; \
        "arm64") TPL_ARCH=arm64; S6_ARCH=aarch64 ;; \
        *) echo "unsupported architecture"; exit 1 ;; \
    esac && \
    apt-get update && \
    apt-get install -y apt-transport-https apt-utils ca-certificates gnupg wget curl git npm make && \
    wget -qO /usr/bin/tpl https://github.com/jitsi/tpl/releases/download/v1.4.0/tpl-linux-${TPL_ARCH} && \
    chmod +x /usr/bin/tpl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Устанавливаем s6-overlay
RUN wget -qO /tmp/s6.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-${S6_ARCH}.tar.gz && \
    mkdir /tmp/s6 && \
    tar xfz /tmp/s6.tar.gz -C /tmp/s6 && \
    tar hxfz /tmp/s6.tar.gz -C / && \
    rm -f /usr/bin/execlineb && \
    cp /tmp/s6/bin/execlineb /usr/bin/ && \
    rm -rf /tmp/s6*

# ❌ УДАЛЯЕМ официальный репозиторий Jitsi (НЕ ИСПОЛЬЗУЕМ .deb пакеты!)
RUN rm -f /etc/apt/sources.list.d/jitsi.list

# 📌 Клонируем ваш форк Jitsi Meet
ARG JITSI_GIT_REPO=https://github.com/sg12/jitsi-meet.git
ARG JITSI_BRANCH=develop-5

RUN git clone --branch ${JITSI_BRANCH} ${JITSI_GIT_REPO} /usr/src/jitsi-meet
WORKDIR /usr/src/jitsi-meet

# Собираем Jitsi Meet
RUN npm install
RUN make

# Копируем собранный код в нужное место
RUN cp -r /usr/src/jitsi-meet /usr/share/jitsi-meet

# Очищаем ненужные файлы
RUN rm -rf /usr/src/jitsi-meet/.git /usr/src/jitsi-meet/node_modules

ENTRYPOINT [ "/init" ]
