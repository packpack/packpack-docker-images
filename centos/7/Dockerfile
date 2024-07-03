ARG ARCH=
FROM ${ARCH}centos:7
MAINTAINER Roman Tsisyk <roman@tarantool.org>

ARG DEVTOOLSET=devtoolset-8
ARG GIT=rh-git227

# Fix missing locales
ENV LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8"

# Set repos url to archive.kernel.org because centos 7 reached EOL and
# original repos are not available anymore
RUN if [ $(uname -m) == 'x86_64' ]; then \
        sed -i '/mirrorlist/d' /etc/yum.repos.d/* \
        && sed -i 's,#baseurl=http://mirror.centos.org,baseurl=http://archive.kernel.org,g' /etc/yum.repos.d/* \
        && sed -i 's,# baseurl=http://mirror.centos.org,baseurl=http://archive.kernel.org,g' /etc/yum.repos.d/* \
        && sed -i 's,$releasever/,7.9.2009/,g' /etc/yum.repos.d/*; \
    elif [ $(uname -m) == 'aarch64' ]; then \
        sed -i '/mirrorlist/d' /etc/yum.repos.d/* \
        && sed -i 's,#baseurl=http://mirror.centos.org,baseurl=http://archive.kernel.org,g' /etc/yum.repos.d/* \
        && sed -i 's,# baseurl=http://mirror.centos.org,baseurl=http://archive.kernel.org,g' /etc/yum.repos.d/* \
        && sed -i 's,$releasever/,7.9.2009/,g' /etc/yum.repos.d/* \
        && sed -i 's,altarch/,centos/altarch/,g' /etc/yum.repos.d/*; \
    fi

# Update repositories and installed packages to avoid of issues got at:
#   https://github.com/tarantool/tarantool-qa/issues/60
RUN yum update -v -y

# Enable extra repositories
RUN yum -y install \
    wget \
    curl \
    pygpgme \
    yum-utils
RUN yum -y install epel-release centos-release-scl centos-release-scl-rh

# Set repos url to archive.kernel.org for SCLo repos
RUN if [ $(uname -m) == 'x86_64' ]; then \
        sed -i '/mirrorlist/d' /etc/yum.repos.d/* \
        && sed -i 's,#baseurl=http://mirror.centos.org,baseurl=http://archive.kernel.org,g' /etc/yum.repos.d/CentOS-SCLo-scl* \
        && sed -i 's,# baseurl=http://mirror.centos.org,baseurl=http://archive.kernel.org,g' /etc/yum.repos.d/CentOS-SCLo-scl* \
        && sed -i 's,7/,7.9.2009/,g' /etc/yum.repos.d/CentOS-SCLo-scl*; \
    elif [ $(uname -m) == 'aarch64' ]; then \
        sed -i '/mirrorlist/d' /etc/yum.repos.d/* \
        && sed -i 's,#baseurl=http://mirror.centos.org,baseurl=http://archive.kernel.org,g' /etc/yum.repos.d/* \
        && sed -i 's,# baseurl=http://mirror.centos.org,baseurl=http://archive.kernel.org,g' /etc/yum.repos.d/* \
        && sed -i 's,7/,7.9.2009/,g' /etc/yum.repos.d/* \
        && sed -i 's,centos/,centos/altarch/,g' /etc/yum.repos.d/CentOS-SCLo-scl*; \
    fi

RUN curl https://packpack.hb.bizmrg.com/backports/el/7/packpack_backports.repo \
    --fail \
    --silent \
    --show-error \
    --retry 5 \
    --retry-delay 5 \
    --output /etc/yum.repos.d/packpack_backports.repo

# Install base toolset
# perl-IPC-Cmd is required for building OpenSSl 3 it's required for
# building tarantool 3, easyier resolve it in this image.
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install \
    ${DEVTOOLSET}-toolchain ${DEVTOOLSET}-binutils-devel \
    ${GIT} \
    cmake cmake28 cmake3 \
    sudo \
    perl-IPC-Cmd

# Fix missing locales
RUN sudo localedef -i en_US -f UTF-8 en_US.UTF-8

# Enable sudo without tty
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers

# Enable devtoolset and ccache system-wide
# See /opt/rh/${DEVTOOLSET}/enable
ENV PATH=/usr/lib64/ccache:/opt/rh/${DEVTOOLSET}/root/usr/bin:/opt/rh/${GIT}/root/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/opt/rh/${DEVTOOLSET}/root/usr/lib64:/opt/rh/${DEVTOOLSET}/root/usr/lib:/opt/rh/httpd24/root/usr/lib64:/opt/rh/httpd24/root/usr/lib
ENV PERL5LIB=/opt/rh/${DEVTOOLSET}/root/usr/lib64/perl5/vendor_perl:/opt/rh/${DEVTOOLSET}/root/usr/lib/perl5:/opt/rh/${DEVTOOLSET}/root/usr/share/perl5/vendor_perl
ENV PYTHONPATH=/opt/rh/${DEVTOOLSET}/root/usr/lib64/python2.7/site-packages:/opt/rh/${DEVTOOLSET}/root/usr/lib/python2.7/site-packages
ENV XDG_CONFIG_DIRS=/opt/rh/${DEVTOOLSET}/root/etc/xdg:/etc/xdg
ENV XDG_DATA_DIRS=/opt/rh/${DEVTOOLSET}/root/usr/share:/usr/local/share:/usr/share

# sudo wrapper from devtoolset is buggy, remove it
RUN rm -f /opt/rh/${DEVTOOLSET}/root/usr/bin/sudo

# A workaround for [Errno 14] HTTP Error 404 - Not Found
# https://bugs.centos.org/view.php?id=12793
RUN sed -e '/\[centos-sclo-sclo-source\]/,+6d' -i /etc/yum.repos.d/CentOS-SCLo-scl.repo
RUN sed -e '/\[centos-sclo-rh-source\]/,+6d' -i /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo

# extras-source is not present for CentOS 7.8, while
# http://vault.centos.org/centos/7 now points to 7.8.2003.
#
# yum-builddep enables the repository and fetching of
# repomd.xml fails with 404 error.
#
# Don't know whether it is temporary effect or not, but
# it worth to remove the repository until it will be
# available on CentOS mirrors.
#
# How to check:
#
# $ curl -fSs 'http://vault.centos.org/centos/7/extras/Source/repodata/repomd.xml'
# curl: (22) The requested URL returned error: 404 Not Found
#
# The output above means that the problem is there.
RUN sed -e '/\[extras-source\]/,+6d' -i /etc/yum.repos.d/CentOS-Sources.repo

# The same as above, but for the updates-source repository.
RUN sed -e '/\[updates-source\]/,+6d' -i /etc/yum.repos.d/CentOS-Sources.repo

# The same as above, but for the base-source repository.
RUN sed -e '/\[base-source\]/,+6d' -i /etc/yum.repos.d/CentOS-Sources.repo

# Cleanup YUM metadata and decrease image size
RUN yum clean all
