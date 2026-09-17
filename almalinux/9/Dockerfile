ARG ARCH=
FROM ${ARCH}almalinux:9
MAINTAINER Oleg Chaplashkin <ochaplashkin@tarantool.org>

# Enable the packpack backports repository: dependencies for building and
# testing that the distribution lacks or ships too old.
RUN curl https://packpack.hb.vkcs.cloud/backports/almalinux/9/packpack_backports.repo \
    --fail \
    --silent \
    --show-error \
    --retry 5 \
    --retry-delay 5 \
    --output /etc/yum.repos.d/packpack_backports.repo

RUN dnf -y install \
        # Install auxiliary tools.
        sudo \
        wget \
        yum-utils \
        # Install extra repositories.
        epel-release && \
    # Install base toolset.
    dnf -y group install 'Development Tools' && \
    dnf -y install cmake && \
    # Enable CRB (CodeReady Builder) - the repository containing
    # additional packages for developers. CRB is an equivalent of
    # PowerTools for CentOS 7/8 and AlmaLinux 8.
    dnf config-manager --set-enabled crb && \
    # Cleanup DNF metadata to decrease image size.
    dnf clean all && \
    rm -rf /var/cache/dnf

# Enable sudo without tty.
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers
