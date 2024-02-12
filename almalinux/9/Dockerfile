ARG ARCH=
FROM ${ARCH}almalinux:9
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
    # Enable CRB (CodeReady Builder) - the repository containing
    # additional packages for developers. CRB is an equivalent of
    # PowerTools for CentOS 7/8 and AlmaLinux 8.
    dnf config-manager --set-enabled crb && \
    # Cleanup DNF metadata to decrease image size.
    dnf clean all && \
    rm -rf /var/cache/dnf

# Enable sudo without tty.
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers
