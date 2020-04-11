FROM centos:8
MAINTAINER Alexey Kopytov <akopytov@gmail.com>

# Enable extra tools
RUN yum -y install wget yum-utils

# Enable extra repositories
RUN yum -y install epel-release
# added PowerTools as suggested at:
#   https://fedoraproject.org/wiki/EPEL
RUN yum config-manager --set-enabled PowerTools

# - fix missing locales
ENV LC_ALL="C" LANG="en_US.UTF-8"

# Install base toolset
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install \
    cmake \
    sudo

# Enable sudo without tty
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers
