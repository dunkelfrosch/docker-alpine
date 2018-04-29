#
# BUILD    : DF/[CORE][ALPINE][JDK]
# OS/CORE  : alpine
# SERVICES : ...
#
# VERSION 1.0.0
#

FROM alpine:3.7

LABEL maintainer="Patrick Paechnatz <patrick.paechnatz@gmail.com>" \
      com.container.vendor="dunkelfrosch impersonate" \
      com.container.service="core/alpine" \
      com.container.priority="1" \
      com.container.project="alpine" \
      img.version="1.0.0" \
      img.description="alpine base image container"

ARG DOCKERIZE_VERSION=v0.6.1

ENV TERM="xterm" \
    TIMEZONE="Europe/Berlin" \
    LANG="en_US.UTF-8" \
    DF_HOME=/var/dunkelfrosch

# prepare system path structure
RUN mkdir -p ${DF_HOME:-/var/df-docker}

# install glibc using origin sources
RUN export GLIBC_VERSION=2.26-r0 && \
    apk add --update ca-certificates bash su-exec gzip curl wget tzdata tini openssl && \
    wget -q --directory-prefix=/tmp https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    wget -q --directory-prefix=/tmp https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk && \
    wget -q --directory-prefix=/tmp https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk && \
    apk add --allow-untrusted /tmp/glibc-${GLIBC_VERSION}.apk && \
    apk add --allow-untrusted /tmp/glibc-bin-${GLIBC_VERSION}.apk && \
    apk add --allow-untrusted /tmp/glibc-i18n-${GLIBC_VERSION}.apk && \
    /usr/glibc-compat/bin/localedef -i ${ISO_LANGUAGE}_${ISO_COUNTRY} -f UTF-8 ${ISO_LANGUAGE}_${ISO_COUNTRY}.UTF-8 && \
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" >/etc/timezone && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

# install wait-for-it script from github author "vishnubob"
RUN wget -q --directory-prefix=/usr/bin/wait-for-it https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x /usr/bin/wait-for-it

# install dockerize script base from github author "jwilder"
RUN wget -q https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && rm dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz

RUN apk del ca-certificates wget curl && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/* /var/cache/apk/* /var/log/*

COPY scripts/ ${DF_HOME:-/var/df-docker}/
