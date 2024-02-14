ARG ARCH=
FROM ${ARCH}almalinux:8
MAINTAINER Oleg Chaplashkin <ochaplashkin@tarantool.org>

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
    # Enable PowerTools. It is a repository of software that adds
    # more utilities and resources for programs and development.
    dnf config-manager --set-enabled powertools && \
    # Cleanup DNF metadata to decrease image size.
    dnf clean all && \
    rm -rf /var/cache/dnf

# Enable sudo without tty.
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers
