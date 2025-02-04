ARG JITSI_GIT_REPO=https://github.com/sg12/jitsi-meet.git
ARG JITSI_BRANCH=develop

FROM jitsi/base:latest

LABEL org.opencontainers.image.source="https://github.com/sg12/jitsi-meet"

RUN apt-dpkg-wrap apt-get update && apt-dpkg-wrap apt-get install -y git


RUN git clone --depth 1 -b "$JITSI_BRANCH" "$JITSI_GIT_REPO" /usr/share/jitsi-meet

ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt
COPY rootfs/ /

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y dnsutils cron nginx-extras jitsi-meet-web socat curl jq && \
    mv /usr/share/jitsi-meet/interface_config.js /defaults && \
    rm -f /etc/nginx/conf.d/default.conf && \
    apt-cleanup

EXPOSE 80 443

VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]
