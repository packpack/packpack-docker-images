FROM centos:8
MAINTAINER Alexander V. Tikhonov <avtikhon@tarantool.org>

# Enable extra tools
RUN yum -y install wget yum-utils

# Enable extra repositories
RUN yum -y install epel-release
# added PowerTools as suggested at:
#   https://fedoraproject.org/wiki/EPEL
RUN yum config-manager --set-enabled PowerTools

# Repository for building/testing dependencies that are not present in vanilla
# CentOS and PowerTools / EPEL repositories, e.g. some Python 2 packages
# - fix missing locales
ENV LC_ALL="C" LANG="en_US.UTF-8"
# - install the backport repository
RUN curl -s https://packagecloud.io/install/repositories/packpack/backports/script.rpm.sh | bash

# Install base toolset
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install \
    cmake \
    python3 \
    python3-devel \
    sudo

# Enable sudo without tty
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers
