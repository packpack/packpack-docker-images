ARG ARCH=
FROM ${ARCH}ubuntu:groovy
MAINTAINER Vitaliia Ioffe <v.ioffe@tarantool.org>

# Fix missing locales
ENV LC_ALL="C.UTF-8" LANG="C.UTF-8"

# Skip interactive post-install scripts
ENV DEBIAN_FRONTEND=noninteractive

# Don't install recommends
RUN echo 'apt::install-recommends "false";' > /etc/apt/apt.conf.d/00recommends

# The repositories are moved to the old-releases archive.
#
# https://gist.github.com/dergachev/f5da514802fcbbb441a1
RUN sed -i -r 's/(archive|security).ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

# And the same for arm64 mirros.
RUN sed -i -r 's@ports.ubuntu.com/ubuntu-ports@old-releases.ubuntu.com/ubuntu@g' /etc/apt/sources.list

# Enable extra repositories
RUN apt-get update && apt-get install -y --force-yes \
    apt-transport-https \
    curl \
    wget \
    gnupg \
    ca-certificates \
    software-properties-common

# Enable the packpack backports repository: dependencies for building and
# testing that the distribution lacks or ships too old.
RUN mkdir -p /etc/apt/keyrings && \
    curl https://packpack.hb.vkcs.cloud/backports/gpgkey \
        --fail \
        --silent \
        --show-error \
        --retry 5 \
        --retry-delay 5 \
        --output /etc/apt/keyrings/packpack_backports.asc && \
    echo "deb [signed-by=/etc/apt/keyrings/packpack_backports.asc] https://packpack.hb.vkcs.cloud/backports/ubuntu groovy main" \
        > /etc/apt/sources.list.d/packpack_backports.list

# Install base toolset
RUN apt-get update && apt-get install -y --force-yes \
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
    dh-systemd

# Enable sudo without password
RUN echo '%adm ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
