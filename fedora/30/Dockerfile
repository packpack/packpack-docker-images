FROM fedora:30
MAINTAINER Alexander Turenko <alexander.turenko@tarantool.org>

# Fix missing locales
ENV LC_ALL="C.UTF-8" LANG="C.UTF-8"

# Enable the packpack backports repository: dependencies for building and
# testing that the distribution lacks or ships too old.
#
# dnf of Fedora 30 may be killed by SIGPIPE right after it imports the
# repository key. The known workaround is to create /run/user/0, where
# gpg-agent then keeps its sockets:
# https://bugzilla.redhat.com/show_bug.cgi?id=1769831
# https://github.com/rpm-software-management/libdnf/pull/869
RUN mkdir -p /run/user/0 && \
    curl https://packpack.hb.vkcs.cloud/backports/fedora/30/packpack_backports.repo \
        --fail \
        --silent \
        --show-error \
        --retry 5 \
        --retry-delay 5 \
        --output /etc/yum.repos.d/packpack_backports.repo

# Update repositories and installed packages to avoid of issues got at:
#   https://github.com/tarantool/tarantool-qa/issues/60
RUN echo "Remove disabled 'failovermethod' since Fedora 29"
RUN sed -i '/^failovermethod=/d' /etc/yum.repos.d/*.repo
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
