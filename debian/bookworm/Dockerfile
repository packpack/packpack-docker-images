FROM arm64v8/debian:bookworm
MAINTAINER Andrey Kulikov <amdeich@gmail.com>

# Fix missing locales
ENV LC_ALL="C.UTF-8" LANG="C.UTF-8"

# Skip interactive post-install scripts
ENV DEBIAN_FRONTEND=noninteractive

# Don't install recommends
RUN echo 'apt::install-recommends "false";' > /etc/apt/apt.conf.d/00recommends

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
