FROM lsiobase/alpine:3.12

# set version label
ARG BUILD_DATE="2022-03-26"
ARG VERSION="3.00"
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai USER=admin PASSWD=admin WEBUI_PORT=9091 PORT=51413

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache curl transmission-daemon && \
 mv /usr/share/transmission/web/index.html /usr/share/transmission/web/index.original.html

# copy local files
COPY transmission-daemon  /usr/local/bin/transmission-daemon
COPY transmission-web-control/src /usr/share/transmission/web
COPY root/ /

# ports and volumes
EXPOSE 9091 51413
VOLUME /config /downloads /watch