FROM registry.red-soft.ru/ubi7/ubi:7.3.7-260914

MAINTAINER Sergei Vorontsov "piligrim@rootnix.net"

# Fix missing locales.
ENV LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8"

# Enable the packpack backports repository: dependencies for building and
# testing that the distribution lacks or ships too old.
RUN curl https://packpack.hb.vkcs.cloud/backports/redos/7.3/packpack_backports.repo \
    --fail \
    --silent \
    --show-error \
    --retry 5 \
    --retry-delay 5 \
    --output /etc/yum.repos.d/packpack_backports.repo

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
    dnf -y group install 'Development Tools' && \
    dnf clean all && rm -rf /var/cache/dnf

# Enable sudo without tty.
RUN sed -i -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers
