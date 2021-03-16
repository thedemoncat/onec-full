FROM alpine as downloader
LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG ONEC_VERSION
ARG TYPE=platform83

ARG ONEGET_VER=v0.1.10
WORKDIR /tmp


RUN apk add curl bash\
  && cd /tmp \
  && curl -sL http://git.io/oneget.sh > oneget \
  && chmod +x oneget \ 
  && ./oneget --nicks $TYPE --version-filter $ONEC_VERSION --distrib-filter '.*deb64.*tar.gz$' --extract --rename
  
FROM ghcr.io/thedemoncat/onec_base:latest as base
LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

ARG ONEC_VERSION
ARG TYPE=platform83

COPY --from=downloader /tmp/pack/*.deb /tmp/dist/

RUN cd /tmp/dist/ \ 
    && dpkg -i common-*.deb \
      server-*.deb \
      ws-*.deb \
      client-*.deb \
  && cd .. \
  && rm -rf dist

RUN mkdir -p /root/.1cv8/1C/1cv8/conf/