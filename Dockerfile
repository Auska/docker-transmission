FROM lsiobase/alpine:3.12 as build

COPY root/ /

ENV VER=3.00

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache git build-base pkgconf zlib-static openssl-libs-static curl-dev curl-static nghttp2-dev nghttp2-static libevent-dev libevent-static intltool libtool bsd-compat-headers && \
	mkdir transmission && cd transmission && \
	wget https://github.com/transmission/transmission-releases/raw/master/transmission-$VER.tar.xz && \
	tar xf transmission-$VER.tar.xz && \
	cd transmission-$VER && \
	patch -p1 < /defaults/00-xl.patch && \
	./configure --prefix=/usr --enable-utp --with-inotify --enable-cli LIBCURL_LIBS="$(pkg-config --libs --static libcurl)" && \
	make install-strip LDFLAGS="-all-static" && \
	mv /usr/share/transmission/web/index.html /usr/share/transmission/web/index.original.html && \
	git clone --depth=1 https://github.com/ronggang/transmission-web-control.git /tmp/twc && \
	cd /tmp/twc/src/ && \
	cp -r * /usr/share/transmission/web/ && \
	mkdir /done && \
	cp --parents /usr/bin/transmission-* /done && \
	cp --parents -r /usr/share/transmission/web/* /done

FROM lsiobase/alpine:3.12

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="blog.auska.win version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai USER=admin PASSWD=admin WEBUI_PORT=9091 PORT=51413 UPDATE=No

# copy local files
COPY --from=build  /done  /
COPY root/ /

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache nghttp2-libs libcurl libevent

# ports and volumes
EXPOSE 9091 51413
VOLUME /config /downloads /watch