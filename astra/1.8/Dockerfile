FROM registry.astralinux.ru/library/astra/ubi18:1.8.1uu2
LABEL org.opencontainers.image.authors="Roman Proskin <opomuc@gmail.com>"

# Fix missing locales
ENV LC_ALL="C.UTF-8" LANG="C.UTF-8"

# Skip interactive post-install scripts
ENV DEBIAN_FRONTEND=noninteractive

# Don't install recommends
RUN echo 'apt::install-recommends "false";' > /etc/apt/apt.conf.d/00recommends

# Enable extra repositories
RUN apt-get update && apt-get install -y --force-yes \
    apt-transport-https \
    curl \
    wget \
    gnupg \
    ca-certificates

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
    equivs \
    rpm \
    alien \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable sudo without password
RUN echo '%adm ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
