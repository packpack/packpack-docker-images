ARG ARCH=
FROM ${ARCH}ubuntu:rolling
MAINTAINER Artem Morozov <amorozov@tarantool.org>

# Fix missing locales
ENV LC_ALL="C.UTF-8" LANG="C.UTF-8"

# Skip interactive post-install scripts
ENV DEBIAN_FRONTEND=noninteractive

# Don't install recommends
RUN echo 'apt::install-recommends "false";' > /etc/apt/apt.conf.d/00recommends

# Enable extra repositories and base toolset
RUN apt-get update && apt-get install -y --force-yes \
    apt-transport-https \
    curl \
    wget \
    gnupg \
    ca-certificates \
    software-properties-common \
    sudo \
    git \
    build-essential \
    cmake \
    gdb \
    ccache \
    devscripts \
    debhelper \
    cdbs \
    fakeroot \
    lintian \
    equivs \
    rpm \
    alien \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable sudo without password
RUN echo '%adm ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
