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

ARG JITSI_REPO=jitsi
ARG BASE_TAG=latest
FROM custom-jitsi-base

LABEL org.opencontainers.image.title="Jitsi Meet"
LABEL org.opencontainers.image.description="WebRTC compatible JavaScript application that uses Jitsi Videobridge to provide high quality, scalable video conferences."
LABEL org.opencontainers.image.url="https://jitsi.org/jitsi-meet/"
LABEL org.opencontainers.image.source="https://github.com/sg12/jitsi-meet"
LABEL org.opencontainers.image.documentation="https://jitsi.github.io/handbook/"

# Задаём аргументы для загрузки кода
ARG JITSI_GIT_REPO=https://github.com/sg12/jitsi-meet.git
ARG JITSI_BRANCH=develop-5

# Устанавливаем зависимости
RUN apt-dpkg-wrap apt-get update && \
    apt-dpkg-wrap apt-get install -y dnsutils cron nginx-extras socat curl jq git npm make && \
    apt-cleanup

# Удаляем старый код, если он был
RUN rm -rf /usr/share/jitsi-meet

# Клонируем ваш репозиторий
RUN git clone --branch ${JITSI_BRANCH} ${JITSI_GIT_REPO} /usr/src/jitsi-meet

# Переходим в папку с кодом
WORKDIR /usr/src/jitsi-meet

# Устанавливаем зависимости и собираем фронтенд
RUN npm install
RUN make

# Копируем собранный код в папку, где Nginx его будет раздавать
RUN cp -r /usr/src/jitsi-meet /usr/share/jitsi-meet

# Добавляем `acme.sh` (если он ещё нужен)
ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt

# Копируем конфиги и настройки
COPY rootfs/ /

# Очищаем ненужные файлы
RUN rm -rf /usr/src/jitsi-meet/.git && \
    rm -rf /usr/src/jitsi-meet/node_modules

EXPOSE 80 443

VOLUME ["/config", "/usr/share/jitsi-meet/transcripts"]

