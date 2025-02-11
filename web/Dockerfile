FROM docker.io/library/debian:bookworm-slim

# Аргументы сборки
ARG JITSI_RELEASE=stable

# Переменные окружения
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Устанавливаем зависимости, определяем архитектуру, устанавливаем TPL, S6 overlay, acme.sh и gettext
RUN dpkgArch="$(dpkg --print-architecture)" && \
    case "${dpkgArch##*-}" in \
        "amd64") TPL_ARCH=amd64; S6_ARCH=amd64 ;; \
        "arm64") TPL_ARCH=arm64; S6_ARCH=aarch64 ;; \
        *) echo "unsupported architecture"; exit 1 ;; \
    esac && \
    echo "Using architecture: TPL_ARCH=${TPL_ARCH}, S6_ARCH=${S6_ARCH}" && \
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
        net-tools \
        gettext-base && \
    rm -rf /var/lib/apt/lists/* && \
    # Устанавливаем tpl
    curl -fsSL -o /usr/bin/tpl "https://github.com/jitsi/tpl/releases/download/v1.4.0/tpl-linux-${TPL_ARCH}" && \
    chmod +x /usr/bin/tpl && \
    # Устанавливаем S6 overlay
    curl -fsSL -o /tmp/s6.tar
