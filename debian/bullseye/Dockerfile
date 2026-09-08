ARG ARCH=
FROM ${ARCH}debian:bullseye
MAINTAINER Andrey Kulikov <amdeich@gmail.com>

# Fix missing locales
ENV LC_ALL="C.UTF-8" LANG="C.UTF-8"

# Skip interactive post-install scripts
ENV DEBIAN_FRONTEND=noninteractive

# Don't install recommends
RUN echo 'apt::install-recommends "false";' > /etc/apt/apt.conf.d/00recommends

# Use the archive repository for bullseye itself and the snapshot
# repository for bullseye-security (the latter is not on
# archive.debian.org yet). bullseye-updates is dropped, because on
# archive.debian.org it is the same or older than bullseye itself.
ADD sources.list /etc/apt/

# The snapshot's Release file is expired: bullseye-security hsa not been
# updated since the end of LTS support, 2026-08-31.
RUN echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/00nocheckvalid

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    wget \
    gnupg \
    ca-certificates

# Install base toolset
RUN apt-get update && apt-get install -y \
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
    alien

# Enable sudo without password
RUN echo '%adm ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
