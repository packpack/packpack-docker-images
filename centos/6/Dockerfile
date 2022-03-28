FROM centos:6
MAINTAINER Roman Tsisyk <roman@tarantool.org>

# 'Vault' archives do not provide devtoolset-6 (see [1]), which
# was used in this image before. So, let's use devtoolset-7.
#
# [1]: https://vault.centos.org/centos/6/sclo/x86_64/rh/Packages/d/
ARG DEVTOOLSET=devtoolset-7

# Replace mirror.centos.org with vault.centos.org. The former
# has no CentOS 6 repositories anymore.
ADD CentOS-Base.repo /etc/yum.repos.d/
RUN yum -y makecache

# Fix missing locales
ENV LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8"

# The base image may contain non-latest packages.
#
# It looks worthful to update them at this point. For example,
# ca-certificates update may be important for HTTPS usage.
RUN yum -y update

# Install software collections and EPEL repositories.
ADD CentOS-SCLo-scl.repo /etc/yum.repos.d/
ADD CentOS-SCLo-scl-rh.repo /etc/yum.repos.d/
RUN yum -y makecache
RUN yum -y install epel-release

# Install backports repository.
RUN yum -y install \
    wget \
    curl \
    pygpgme \
    yum-utils
RUN curl https://packpack.hb.bizmrg.com/backports/el/6/packpack_backports.repo \
    --fail \
    --silent \
    --show-error \
    --retry 5 \
    --retry-delay 5 \
    --output /etc/yum.repos.d/packpack_backports.repo
RUN yum -y makecache && yum clean all

# Install base toolset
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install \
    ${DEVTOOLSET}-toolchain ${DEVTOOLSET}-binutils-devel \
    cmake cmake28 cmake3 \
    sudo \
    vim-minimal

# Enable sudo without tty
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers

# Enable devtoolset and ccache system-wide
# See /opt/rh/${DEVTOOLSET}/enable
ENV PATH=/usr/lib64/ccache:/opt/rh/${DEVTOOLSET}/root/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/opt/rh/${DEVTOOLSET}/root/usr/lib64:/opt/rh/${DEVTOOLSET}/root/usr/lib
ENV PERL5LIB=/opt/rh/${DEVTOOLSET}/root/usr/lib64/perl5/vendor_perl:/opt/rh/${DEVTOOLSET}/root/usr/lib/perl5:/opt/rh/${DEVTOOLSET}/root/usr/share/perl5/vendor_perl
ENV PYTHONPATH=/opt/rh/${DEVTOOLSET}/root/usr/lib64/python2.7/site-packages:/opt/rh/${DEVTOOLSET}/root/usr/lib/python2.7/site-packages
ENV XDG_CONFIG_DIRS=/opt/rh/${DEVTOOLSET}/root/etc/xdg:/etc/xdg
ENV XDG_DATA_DIRS=/opt/rh/${DEVTOOLSET}/root/usr/share:/usr/local/share:/usr/share
# sudo wrapper from devtoolset is buggy, remove it
RUN rm -f /opt/rh/${DEVTOOLSET}/root/usr/bin/sudo
