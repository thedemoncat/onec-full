FROM demoncat/onec-base:latest as base
LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

ARG TYPE=platform83

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG ONEC_VERSION
ARG TYPE=platform83

ARG ONEGET_VER=v0.5.2
WORKDIR /tmp

RUN set -xe; \
  apt update; \
  apt install -y \ 
    curl \
    bash \
    gzip \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    geoclue-2.0; \
    rm -rf /var/lib/apt/lists/*

RUN set -xe; \
  mkdir /tmp/onec; \
  cd /tmp/onec; \ 
  curl -sL http://git.io/oneget.sh > oneget; \
  chmod +x oneget; \ 
  ./oneget --debug get  --extract --rename platform:linux.full.x64@$ONEC_VERSION; \
  cd ./downloads/$TYPE/$ONEC_VERSION/server64.$ONEC_VERSION.tar.gz.extract; \ 
  ./setup-full-$ONEC_VERSION-x86_64.run --mode unattended  --enable-components client_thin,ws,server_admin,server  --installer-language en; \
  cd /tmp; \
  rm -rf /tmp/onec

COPY ./scripts/create_symlink.sh create_symlink.sh

RUN set -e \
  && chmod +x create_symlink.sh \
  && ./create_symlink.sh $ONEC_VERSION