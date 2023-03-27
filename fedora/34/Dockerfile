ARG ARCH=
FROM ${ARCH}fedora:34
MAINTAINER Vitaliia Ioffe <v.ioffe@tarantool.org>

# Fix missing locales
ENV LC_ALL="C.UTF-8" LANG="C.UTF-8"

# The support for Fedora Linux ended on June 7, 2022. 
# The package repository has been moved to 
# http://archives.fedoraproject.org. 

RUN sed -i 's/metalink=/#metalink=/g' /etc/yum.repos.d/*
RUN sed -i 's/#baseurl=/baseurl=/g' /etc/yum.repos.d/*
RUN sed -i 's/download.example\/pub/archives.fedoraproject.org\/pub\/archive/g' /etc/yum.repos.d/*

# Update repositories and installed packages to avoid of issues got at:
#   https://github.com/tarantool/tarantool-qa/issues/60
RUN dnf update -v -y

# Install base toolset
RUN dnf -y group install 'Development Tools'
RUN dnf -y group install 'C Development Tools and Libraries'
RUN dnf -y group install 'RPM Development Tools'
RUN dnf -y install fedora-packager
RUN dnf -y install sudo git ccache cmake

# Enable cache system-wide
ENV PATH /usr/lib/ccache:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

# Enable sudo without tty
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers

# Cleanup DNF metadata and decrease image size
RUN dnf clean all
