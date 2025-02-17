ARG CHROME_RELEASE=130.0.6723.116

# Используем OpenJDK 11 в качестве базового образа
FROM openjdk:11-jre-slim

LABEL org.opencontainers.image.title="Jitsi Broadcasting Infrastructure (jibri)"
LABEL org.opencontainers.image.description="Components for recording and/or streaming a conference."
LABEL org.opencontainers.image.url="https://github.com/jitsi/jibri"
LABEL org.opencontainers.image.source="https://github.com/jitsi/docker-jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

COPY rootfs/ /

RUN apt-get update && \
    apt-get install -y \
        jibri \
        libgl1-mesa-dri \
        procps \
        jq \
        pulseaudio \
        dbus \
        dbus-x11 \
        rtkit \
        unzip \
        fonts-noto \
        fonts-noto-cjk \
        libcap2-bin && \
    apt-get clean && \
    adduser jibri rtkit && \
    dpkgArch="$(dpkg --print-architecture)" && \
    case "${dpkgArch##*-}" in \
        "amd64") SC_ARCH=x86_64 ;; \
        "arm64") SC_ARCH=aarch64 ;; \
        *) echo "unsupported architecture"; exit 1 ;; \
    esac && \
    wget -qO /usr/bin/shm-check https://github.com/saghul/shm-check/releases/download/v1.0.0/shm-check-${SC_ARCH} && \
    chmod +x /usr/bin/shm-check

VOLUME /config
