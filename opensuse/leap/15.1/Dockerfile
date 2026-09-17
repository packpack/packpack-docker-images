FROM opensuse/leap:15.1
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

# Enable the packpack backports repository: dependencies for building and
# testing that the distribution lacks or ships too old.
#
# zypper asks before it trusts a new repository key. The refresh imports the
# key into the image, so later zypper calls use the repository without the
# question: --non-interactive keeps the refresh from waiting for an answer,
# and --gpg-auto-import-keys makes it trust the key instead of rejecting it.
RUN curl https://packpack.hb.vkcs.cloud/backports/opensuse-leap/15.1/packpack_backports.repo \
    --fail \
    --silent \
    --show-error \
    --retry 5 \
    --retry-delay 5 \
    --output /etc/zypp/repos.d/packpack_backports.repo && \
    zypper --non-interactive --gpg-auto-import-keys refresh \
        packpack_backports packpack_backports-source

# Enable sudo without password
RUN echo '%users ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
