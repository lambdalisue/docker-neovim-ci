FROM ubuntu:20.04 AS base
MAINTAINER lambdalisue <lambdalisue@hashnote.net>

ARG NEOVIM_PREFIX=/opt/neovim
ENV NEOVIM_PREFIX=$NEOVIM_PREFIX

ENV PATH=${NEOVIM_PREFIX}/bin:$PATH

FROM base AS neovim

RUN apt-get update \
 && apt-get install -y \
    curl \
    ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

ARG NEOVIM_VERSION
RUN echo "${NEOVIM_VERSION}" \
 && curl -SL https://github.com/neovim/neovim/archive/${NEOVIM_VERSION}.tar.gz | tar -xz
RUN cd $(find . -name 'neovim-*' -type d | head -1) \
 && make \
    CMAKE_BUILD_TYPE=RelWithDebInfo \
    CMAKE_EXTRA_FLAGS="-DENABLE_JEMALLOC=OFF -DCMAKE_INSTALL_PREFIX=${NEOVIM_PREFIX}" \
 && make install

FROM base

COPY --from=neovim ${NEOVIM_PREFIX} ${NEOVIM_PREFIX}

ENTRYPOINT "${NEOVIM_PREFIX}/bin/nvim"
CMD []
