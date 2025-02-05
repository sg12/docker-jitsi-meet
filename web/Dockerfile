ADD file:d48a85028743f16ed927507322e3e3beee187fbfadd0b781d4b89de197c64b5b in / 
CMD ["bash"]
ARG JITSI_RELEASE=stable
ARG FREP_VERSION=1.3.11
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
COPY rootfs / # buildkit

RUN |2 JITSI_RELEASE=unstable FREP_VERSION=1.3.11 /bin/sh -c apt-dpkg-wrap apt-get update &&     apt-dpkg-wrap apt-get install -y apt-transport-https apt-utils ca-certificates gnupg wget &&     wget -qO - https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz | tar xfz - -C / &&     wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | gpg --dearmour > /etc/apt/trusted.gpg.d/jitsi.gpg &&     wget -qO /usr/bin/frep https://github.com/subchen/frep/releases/download/v$FREP_VERSION/frep-$FREP_VERSION-linux-amd64 &&     echo "deb https://download.jitsi.org $JITSI_RELEASE/" > /etc/apt/sources.list.d/jitsi.list &&     echo "deb http://ftp.debian.org/debian bullseye-backports main" > /etc/apt/sources.list.d/backports.list &&     apt-dpkg-wrap apt-get update &&     apt-dpkg-wrap apt-get dist-upgrade -y &&     apt-cleanup &&     chmod +x /usr/bin/frep # buildkit

RUN |2 JITSI_RELEASE=unstable FREP_VERSION=1.3.11 /bin/sh -c [ "$JITSI_RELEASE" = "unstable" ] &&     apt-dpkg-wrap apt-get update &&     apt-dpkg-wrap apt-get install -y jq procps curl vim iputils-ping net-tools &&     apt-cleanup ||     true # buildkit

ENTRYPOINT ["/init"]

LABEL org.opencontainers.image.title=Jitsi Meet

LABEL org.opencontainers.image.description=WebRTC compatible JavaScript application that uses Jitsi Videobridge to provide high quality, scalable video conferences.

LABEL org.opencontainers.image.url=https://jitsi.org/jitsi-meet/

LABEL org.opencontainers.image.source=https://github.com/jitsi/docker-jitsi-meet

LABEL org.opencontainers.image.documentation=https://jitsi.github.io/handbook/

ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/2.8.8/acme.sh /opt # buildkit

COPY rootfs/ / # buildkit

RUN /bin/sh -c apt-dpkg-wrap apt-get update &&     apt-dpkg-wrap apt-get install -y cron nginx-extras jitsi-meet-web socat &&     apt-dpkg-wrap apt-get -d install -y jitsi-meet-web-config &&     dpkg -x /var/cache/apt/archives/jitsi-meet-web-config*.deb /tmp/pkg &&     mv /tmp/pkg/usr/share/jitsi-meet-web-config/config.js /defaults &&     mv /usr/share/jitsi-meet/interface_config.js /defaults &&     rm -f /etc/nginx/conf.d/default.conf &&     apt-cleanup &&     rm -rf /tmp/pkg /var/cache/apt # buildkit

EXPOSE map[443/tcp:{} 80/tcp:{}]

VOLUME [/config /usr/share/jitsi-meet/transcripts]
