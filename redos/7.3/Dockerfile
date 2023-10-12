FROM registry.red-soft.ru/ubi7/ubi-minimal:7.3.3-231009
MAINTAINER Sergei Vorontsov "piligrim@rootnix.net"

ENV BACKPORTS_REPO_FILE=https://packpack.hb.bizmrg.com/backports/redos/7.3/packpack_backports.repo

RUN curl $BACKPORTS_REPO_FILE \
    --fail \
    --silent \
    --show-error \
    --retry 5 \
    --retry-delay 5 \
    --output /etc/yum.repos.d/$(basename $BACKPORTS_REPO_FILE)

# Install base toolset for building and packaging projects.
RUN dnf -y update && \
    dnf -y install \
        rpm-devel \
        rpmdevtools \
        rpm-build \
        ccache \
        git \
        sudo \
        dnf-utils && \
    dnf -y groupinstall 'Development Tools'

# Enable sudo without tty.
RUN sed -i -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers

# Cleanup DNF metadata and decrease image size
RUN dnf clean all

CMD ["/bin/bash"]
