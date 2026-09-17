ARG ARCH=
FROM ${ARCH}fedora:37
MAINTAINER Sergey Vorontsov <piligrim@rootnix.net>

# Fix missing locales
ENV LC_ALL="C.UTF-8" LANG="C.UTF-8"

# Enable the packpack backports repository: dependencies for building and
# testing that the distribution lacks or ships too old.
RUN curl https://packpack.hb.vkcs.cloud/backports/fedora/37/packpack_backports.repo \
    --fail \
    --silent \
    --show-error \
    --retry 5 \
    --retry-delay 5 \
    --output /etc/yum.repos.d/packpack_backports.repo

# Update repositories and installed packages to avoid issues from:
#   https://github.com/tarantool/tarantool-qa/issues/60
RUN dnf update -v -y && \
# Install base toolset
	dnf -y group install \
		'Development Tools' \
		'C Development Tools and Libraries' \
		'RPM Development Tools' && \
	dnf -y install \
		fedora-packager \
		sudo \
		git \
		ccache \
		cmake && \
# Cleanup DNF metadata and decrease image size
	dnf clean all

# Enable cache system-wide
ENV PATH /usr/lib/ccache:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

# Enable sudo without tty
RUN sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers
