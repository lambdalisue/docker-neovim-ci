ARG BRANCH=${BRANCH:-master}
FROM alpine:latest
MAINTAINER lambdalisue <lambdalisue@hashnote.net>

# Install build dependencies and required packages
# and Build Neovim
# https://github.com/neovim/neovim/issues/2364
# https://github.com/neovim/neovim/issues/2633
# 'diffutils' is required while busybox's diff supports
# only unified diff style
# https://busybox.net/downloads/BusyBox.html
RUN apk add --no-cache --virtual build-deps \
    curl git make file libtermkey-dev libvterm-dev \
    libtool autoconf automake cmake g++ pkgconfig unzip \
 && apk add --no-cache libtermkey libvterm libgcc diffutils \
 && git clone --depth 1 --single-branch --branch ${BRANCH} https://github.com/neovim/neovim \
 && cd neovim \
 && make CMAKE_BUILD_TYPE=Release DEPS_CMAKE_FLAGS="-DUSE_BUNDLED_JEMALLOC=OFF"\
 && make install \
 && cd ../ && rm -rf neovim \
 && apk del build-deps

VOLUME /mnt/volume
WORKDIR /mnt/volume
ENTRYPOINT ["/usr/local/bin/nvim"]
CMD []
