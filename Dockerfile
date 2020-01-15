FROM lsiobase/alpine:3.11 as build

COPY root/ /

ENV VER=2.94

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache git build-base transmission-daemon autoconf automake pkgconf curl-dev libevent-dev intltool libtool bsd-compat-headers && \
	git clone https://github.com/ronggang/transmission-web-control.git /tmp/twc && \
	cd /tmp && \
	tar zcf twc.tar.gz twc/src/* && \
	mkdir transmission && cd transmission && \
	wget https://github.com/transmission/transmission-releases/raw/master/transmission-$VER.tar.xz && \
	tar xf transmission-$VER.tar.xz && \
	cd transmission-$VER && \
	patch -p1 < /defaults/00-xl.patch && \
	./configure --disable-nls && \
	make install-strip && \
	mkdir /done && \
	cp --parents /usr/local/bin/transmission-daemon /done

FROM lsiobase/alpine:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="blog.auska.win version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai USER=admin PASSWD=admin WEBUI_PORT=9091 PORT=51413

# copy local files
COPY --from=build  /tmp/twc.tar.gz  /tmp
COPY --from=build  /done  /
COPY root/ /

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache transmission-cli transmission-daemon && \
	cp -rf /usr/share/transmission/web/index.html /usr/share/transmission/web/index.original.html && \
	tar xf /tmp/twc.tar.gz -C /usr/share/transmission/web/

# ports and volumes
EXPOSE 9091 51413
VOLUME /config /downloads /watch