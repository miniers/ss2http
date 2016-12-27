FROM alpine:latest
MAINTAINER miniers

#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

RUN \
  apk --update --upgrade add \
      privoxy

RUN buildDeps=" \
            		build-base \
            		curl \
            		linux-headers \
            		openssl-dev \
            		tar \
      	"; \
      	set -x \
      	&& apk add --update openssl \
      	&& apk add $buildDeps \
      	&& SS_VERSION=`curl "https://github.com/shadowsocks/shadowsocks-libev/releases/latest" | sed -n 's/^.*tag\/\(.*\)".*/\1/p'` \
      	&& curl -SL "https://github.com/shadowsocks/shadowsocks-libev/archive/$SS_VERSION.tar.gz" -o ss.tar.gz \
      	&& mkdir -p /usr/src/ss \
      	&& tar -xf ss.tar.gz -C /usr/src/ss --strip-components=1 \
      	&& rm ss.tar.gz \
      	&& cd /usr/src/ss \
      	&& ./configure \
      	&& make install \
      	&& cd / \
      	&& rm -fr /usr/src/ss \
      	&& apk del $buildDeps \
      	&& rm -rf /var/cache/apk/*

ENV SERVER_ADDR= \
    SERVER_PORT=8899  \
    METHOD=chacha20 \
    TIMEOUT=300 \
    PASSWORD=

#------------------------------------------------------------------------------
# Populate root file system:
#------------------------------------------------------------------------------

ADD rootfs /

#------------------------------------------------------------------------------
# Expose ports and entrypoint:
#------------------------------------------------------------------------------
EXPOSE 8118 7070

ENTRYPOINT ["/entrypoint.sh"]