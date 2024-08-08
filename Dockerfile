FROM lsiobase/alpine:3.12

# set version label
ARG BUILD_DATE="2024-08-08"
ARG VERSION="4.0.6"
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai USER=admin PASSWD=admin WEBUI_PORT=9091 PORT=51413

# copy local files
COPY transmission-daemon  /usr/bin/transmission-daemon
COPY trguing-web-v1.3.0 /usr/share/transmission/public_html
COPY root/ /

# ports and volumes
EXPOSE 9091 51413
VOLUME /config /downloads /watch
