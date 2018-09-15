FROM alpine:latest
MAINTAINER lambdalisue <lambdalisue@hashnote.net>

# Install build dependencies and required packages
# and Build Neovim
# https://github.com/neovim/neovim/issues/2364
# https://github.com/neovim/neovim/issues/2633
# 'diffutils' is required while busybox's diff supports
# only unified diff style
# https://busybox.net/downloads/BusyBox.html
# iconv in alpine is a bit different from usual one so
# replace it to support 'iconv()' correctly in Vim
ARG OPTIONS
RUN apk add --no-cache --virtual build-deps \
    curl git make file libtermkey-dev libvterm-dev gettext-dev \
    libtool autoconf automake cmake g++ pkgconfig unzip \
 && apk add --no-cache libtermkey libvterm libgcc diffutils gettext \
 && echo "Install official 'iconv'" \
 && curl -SL http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz | tar -xz \
 && cd libiconv-1.15 \
 && ./configure \
 && make \
 && make install \
 && cd ../ && rm -rf libiconv-1.15 \
 && echo "Install Neovim with $OPTIONS" \
 && git clone --depth 1 --single-branch $OPTIONS https://github.com/neovim/neovim \
 && cd neovim \
 && git log -1 \
 && make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DENABLE_JEMALLOC=OFF" \
 && make install \
 && cd ../ && rm -rf neovim \
 && apk del build-deps

VOLUME /mnt/volume
WORKDIR /mnt/volume
ENTRYPOINT ["/usr/local/bin/nvim"]
CMD []
