ARG ARCH=
FROM ${ARCH}centos:8
MAINTAINER Alexander V. Tikhonov <avtikhon@tarantool.org>

# CentOS Linux 8 reached End Of Life on December 31st, 2021. The mirror list
# with http://mirrorlist.centos.org doesn't work for it. The base URL with
# http://mirror.centos.org doesn't work as well. So enabling repos from vault
# mirrors:
#   https://github.com/CentOS/sig-cloud-instance-images/issues/190
RUN find /etc/yum.repos.d/ -type f -exec sed -i 's/mirrorlist=/#mirrorlist=/g' {} +
RUN find /etc/yum.repos.d/ -type f -exec sed -i 's/#baseurl=/baseurl=/g' {} +
RUN find /etc/yum.repos.d/ -type f -exec sed -i 's/mirror.centos.org/vault.centos.org/g' {} +

# Update repositories and installed packages to avoid of issues got at:
#   https://github.com/tarantool/tarantool-qa/issues/60
RUN dnf update -v -y

# Enable extra tools
RUN yum -y install wget yum-utils

# Enable extra repositories
RUN yum -y install epel-release
# added PowerTools as suggested at:
#   https://fedoraproject.org/wiki/EPEL
RUN sed -i 's/\[PowerTools\]/[powertools]/g' /etc/yum.repos.d/*.repo
RUN yum config-manager --set-enabled powertools

# Repository for building/testing dependencies that are not present in vanilla
# CentOS and PowerTools / EPEL repositories, e.g. some Python 2 packages
# - install the backport repository
RUN curl -s https://packagecloud.io/install/repositories/packpack/backports/script.rpm.sh | bash

# Install base toolset
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install \
    cmake \
    sudo

# Enable sudo without tty
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers

# Cleanup DNF metadata and decrease image size
RUN dnf clean all
