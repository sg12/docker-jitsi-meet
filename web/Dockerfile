ARG JITSI_GIT_REPO
ARG JITSI_BRANCH
ARG LOCAL_JITSI_PATH

FROM jitsi/base:stable

LABEL org.opencontainers.image.source="https://github.com/sg12/jitsi-meet"

RUN apt-dpkg-wrap apt-get update && apt-dpkg-wrap apt-get install -y git

# Проверка аргументов перед клонированием или копированием
RUN if [ -n "$LOCAL_JITSI_PATH" ] ; then \
        echo "Используем локальную версию Jitsi Meet из $LOCAL_JITSI_PATH" && \
        cp -r $LOCAL_JITSI_PATH /usr/share/jitsi-meet ; \
    else \
        echo "Cloning from ${JITSI_GIT_REPO:-https://github.com/sg12/jitsi-meet.git}, branch ${JITSI_BRANCH:-develop}" && \
        git clone --depth 1 -b "${JITSI_BRANCH:-develop}" "${JITSI_GIT_REPO:-https://github.com/sg12/jitsi-meet.git}" /usr/share/jitsi-meet || \
        (echo "Ошибка: Репозиторий не найден или неверный branch"; exit 1) ; \
    fi

ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt

RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y dnsutils cron nginx-extras jitsi-meet-web socat curl jq && \
    mv /usr/share/jitsi-meet/interface_config.js /defaults && \
    rm -f /etc/nginx/conf.d/default.conf && \
    apt-cleanup

# Копируем кастомный конфиг nginx в контейнер
COPY web/rootfs/etc/nginx/sites-available/default /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default


EXPOSE 8443 8000

VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

CMD ["nginx", "-g", "daemon off;"]

