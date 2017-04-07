FROM centos:6
MAINTAINER Roman Tsisyk <roman@tarantool.org>

# Fix missing locales
ENV LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8"

# Enable extra repositories
RUN yum -y install \
    wget \
    curl \
    pygpgme \
    yum-utils
RUN yum -y install epel-release
ADD CentOS-SCLo-scl.repo /etc/yum.repos.d/
ADD CentOS-SCLo-scl-rh.repo /etc/yum.repos.d/
RUN curl -s https://packagecloud.io/install/repositories/packpack/backports/script.rpm.sh | bash
RUN yum makecache && yum clean all

# Install base toolset
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install \
    devtoolset-6-toolchain devtoolset-6-binutils-devel \
    cmake cmake28 cmake3 \
    sudo

# Enable sudo without tty
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers

# Enable devtoolset and ccache system-wide
# See /opt/rh/devtoolset-6/enable
ENV PATH=/usr/lib64/ccache:/opt/rh/devtoolset-6/root/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/opt/rh/devtoolset-6/root/usr/lib64:/opt/rh/devtoolset-6/root/usr/lib
ENV PERL5LIB=/opt/rh/devtoolset-6/root//usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-6/root/usr/lib/perl5:/opt/rh/devtoolset-6/root//usr/share/perl5/vendor_perl
ENV PYTHONPATH=/opt/rh/devtoolset-6/root/usr/lib64/python2.6/site-packages:/opt/rh/devtoolset-6/root/usr/lib/python2.6/site-packages
ENV XDG_CONFIG_DIRS=/opt/rh/devtoolset-6/root/etc/xdg:/etc/xdg
ENV XDG_DATA_DIRS=/opt/rh/devtoolset-6/root/usr/share:/usr/local/share:/usr/share
# sudo wrapper from devtoolset is buggy, remove it
RUN rm -f /opt/rh/devtoolset-6/root/usr/bin/sudo
