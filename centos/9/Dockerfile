ARG ARCH=
FROM ${ARCH}dokken/centos-stream-9

# Update repositories and installed packages
RUN dnf update -v -y

# Enable extra tools
RUN yum -y install wget yum-utils

# Enable extra repositories
RUN yum -y install epel-release

# # Enable the packpack backports repository: dependencies for building and
# # testing that the distribution lacks or ships too old.
# RUN curl https://packpack.hb.vkcs.cloud/backports/el/9/packpack_backports.repo \
#     --fail \
#     --silent \
#     --show-error \
#     --retry 5 \
#     --retry-delay 5 \
#     --output /etc/yum.repos.d/packpack_backports.repo

# Install base toolset
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install \
    cmake \
    sudo

# Enable sudo without tty
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers

# Cleanup DNF metadata and decrease image size
RUN dnf clean all
