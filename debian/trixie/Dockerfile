ARG ARCH=
FROM ${ARCH}debian:trixie
LABEL org.opencontainers.image.authors="Andrey Kulikov <amdeich@gmail.com>"

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
    echo "deb [signed-by=/etc/apt/keyrings/packpack_backports.asc] https://packpack.hb.vkcs.cloud/backports/debian trixie main" \
        > /etc/apt/sources.list.d/packpack_backports.list

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
