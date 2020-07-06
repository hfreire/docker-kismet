FROM debian:buster-slim AS debian

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.11
RUN set -x \
  && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget gnupg dirmngr && rm -rf /var/lib/apt/lists/* \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && { command -v gpgconf > /dev/null && gpgconf --kill all || :; } \
  && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true \
  && apt-get purge -y --auto-remove ca-certificates wget gnupg dirmngr

RUN set -x \
  && apt-get update && apt-get install -y --no-install-recommends \
    libbz2-1.0 \
    libc6 \
    libcap2 \
    libdw1 \
    libelf1 \
    libffi6 \
    libgcc1 \
    libgcrypt20 \
    libgnutls30 \
    libgmp10 \
    libgomp1 \
    libgpg-error0 \
    libhogweed4 \
    libidn11 \
    libmicrohttpd12 \
    libncurses5 \
    libnettle6 \
    libnl-3-200 \
    libnl-genl-3-200 \
    libp11-kit0 \
    libpcap0.8 \
    libpcre3 \
    libprotobuf17 \
    libsqlite3-0 \
    libstdc++6 \
    libtasn1-6 \
    libtinfo5 \
    liblzma5 \
    zlib1g \
  && rm -rf /var/lib/apt/lists/*

FROM debian AS build

ENV KISMET_VERSION 2020-04-R3
RUN set -x pipefail \
  && apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    build-essential \
    ca-certificates \
    curl \
    git \
    unzip \
    gdb \
    gdbserver \
    pkg-config \
    libmicrohttpd-dev \
    zlib1g-dev \
    libnl-3-dev \
    libnl-genl-3-dev \
    libcap-dev \
    libpcap-dev \
    libncurses5-dev \
    libnm-dev \
    libdw-dev \
    libsqlite3-dev \
    libprotobuf-dev \
    libprotobuf-c-dev \
    protobuf-compiler \
    protobuf-c-compiler \
    librtlsdr0 \
    libusb-1.0 \
  && rm -rf /var/lib/apt/lists/* \
  && curl -fsSLO --compressed "https://github.com/kismetwireless/kismet/archive/kismet-$KISMET_VERSION.zip" \
  && echo "d1fe8e73749893c0a9e6e69628c5baf957f7ac1a6cb0e0d8d5667fda90a9e9e1 *kismet-$KISMET_VERSION.zip" | sha256sum -c - \
  && unzip -d kismet-$KISMET_VERSION kismet-$KISMET_VERSION.zip \
  && cd kismet-$KISMET_VERSION/kismet-kismet-$KISMET_VERSION \
  && ./configure --disable-python-tools \
  && make -j $(nproc) \
  && make install \
  && cd ../.. && rm -rf kismet-$KISMET_VERSION \
  && apt-get purge -y --auto-remove \
    autoconf \
    build-essential \
    ca-certificates \
    curl \
    git \
    unzip \
    gdb \
    gdbserver \
    pkg-config \
    libmicrohttpd-dev \
    zlib1g-dev \
    libnl-3-dev \
    libnl-genl-3-dev \
    libcap-dev \
    libpcap-dev \
    libncurses5-dev \
    libnm-dev \
    libdw-dev \
    libsqlite3-dev \
    libprotobuf-dev \
    libprotobuf-c-dev \
    protobuf-compiler \
    protobuf-c-compiler \
    librtlsdr0 \
    libusb-1.0

FROM debian
LABEL maintainer="hugo@exec.sh"

RUN set -eux; \
  groupadd --gid 1000 kismet; \
  useradd --uid 1000 --gid kismet --shell /bin/bash --create-home kismet
WORKDIR /home/kismet

COPY --from=build /usr/local/ /usr/local/
COPY --chown=kismet:kismet docker-entrypoint.sh docker-entrypoint.sh

ENV PATH $PATH:/usr/local/bin

EXPOSE 2501 3501

ENTRYPOINT ["./docker-entrypoint.sh"]
