FROM alpine as downloader
LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG ONEC_VERSION
ARG TYPE=platform83

ARG ONEGET_VER=v0.0.7
WORKDIR /tmp

RUN apk add curl tar\
  && cd /tmp \
  && curl -L https://github.com/v8platform/oneget/releases/download/$ONEGET_VER/oneget_Linux_x86_64.tar.gz > oneget.tar.gz \
  && tar -zxvf  oneget.tar.gz \
  && rm -f oneget.tar.gz \
  && ./oneget --nicks $TYPE --version-filter $ONEC_VERSION --distrib-filter 'deb64_.*.tar.gz$' \
   && ./oneget --nicks $TYPE --version-filter $ONEC_VERSION --distrib-filter 'deb64.tar.gz$' \
  && rm -f oneget \
  && cd  $TYPE/$ONEC_VERSION \
  && for file in *.tar.gz; do tar -zxf "$file"; done \
  && rm -rf *.tar.gz
  
FROM ghcr.io/thedemoncat/onec-base/onec_base as base
LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

ARG ONEC_VERSION
ARG TYPE=platform83

COPY --from=downloader /tmp/$TYPE/$ONEC_VERSION/*.deb /tmp/dist/

RUN cd /tmp/dist/ \ 
    && dpkg -i 1c-enterprise83-common_*.deb \
      1c-enterprise83-server_*.deb \
      1c-enterprise83-ws_*.deb \
      1c-enterprise83-client_*.deb \
  && cd .. \
  && rm -rf dist

RUN mkdir -p /root/.1cv8/1C/1cv8/conf/