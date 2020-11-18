FROM opensuse/leap:15.2
MAINTAINER Alexander V. Tikhonov <avtikhon@gmail.com>

# Add the same repositories based on Yandex paths as default
RUN for f in /etc/zypp/repos.d/* ; do \
        sed "s#^\(baseurl=http://download.opensuse.org/\)\(.*\)#\1\2\nhttps://mirror.yandex.ru/opensuse/\2#g" -i $f ; \
    done

# Install base toolset
RUN zypper install -y \
    autoconf \
    ccache \
    cmake \
    curl \
    devscripts \
    dnf \
    fakeroot \
    gdb \
    git \
    lsb-release \
    rpm-build \
    sudo \
    tar \
    wget \
    xz \
    yum-utils

# Enable sudo without password
RUN echo '%users ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
