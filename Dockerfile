FROM lsiobase/alpine:3.11 as get

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache git && \
	git clone https://github.com/ronggang/transmission-web-control.git /tmp/twc && \
	cd /tmp && \
	tar zcf twc.tar.gz twc/src/*

FROM lsiobase/alpine:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="blog.auska.win version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai USER=admin PASSWD=admin WEBUI_PORT=9091 PORT=51413

# copy local files
COPY --from=get  /tmp/twc.tar.gz  /tmp
COPY root/ /

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache transmission-cli transmission-daemon && \
	cp -rf /usr/share/transmission/web/index.html /usr/share/transmission/web/index.original.html && \
	tar xf /tmp/twc.tar.gz -C /usr/share/transmission/web/

# ports and volumes
EXPOSE 9091 51413
VOLUME /config /downloads /watch
