FROM centos:7 as prepare
MAINTAINER Sergei Vorontsov "piligrim@rootnix.net"

ENV REPO_URL=http://mirror.yandex.ru/redos/7.3/x86_64/os/ \
    BACKPORTS_REPO_FILE=https://packpack.hb.bizmrg.com/backports/redos/7.3/packpack_backports.repo \
    CHROOT_DIR="/chroot"

RUN mkdir -p $CHROOT_DIR

# Find and download a redos-release package.
RUN rpm="$(curl -s "${REPO_URL}" |                                        \
        grep 'redos-release' |                                            \
        sed 's/^.*<.*>\(.*\)<\/.*>.*$/\1/' |                              \
        grep '^redos-release-[0-9]\.[0-9]-[0-9][0-9]\?.el7.noarch.rpm$' | \
        tail -n 1)";                                                      \
    curl -o ${CHROOT_DIR}/redos-release.rpm ${REPO_URL}${rpm}

# Setup RedOS YUM repository and RedOS specific configuration
# files.
#
# The content of the RPM file is the following.
#
# redos-release-7.3-27.el7.noarch.rpm
# ├── etc
# │   ├── centos-release -> redos-release
# │   ├── issue
# │   ├── issue.net
# │   ├── os-release
# │   ├── pki
# │   │   └── rpm-gpg
# │   │       └── RPM-GPG-KEY-RED-SOFT
# │   ├── redhat-release -> redos-release
# │   ├── redos-release
# │   ├── rpm
# │   │   └── macros.dist
# │   ├── system-release -> redos-release
# │   ├── system-release-cpe
# │   ├── yum
# │   │   └── vars
# │   │       └── releasever
# │   └── yum.repos.d
# │       ├── RedOS-Base.repo
# │       └── RedOS-Updates.repo
# └── usr
#     ├── lib
#     │   └── systemd
#     │       └── system-preset
#     │           ├── 85-display-manager.preset
#     │           ├── 90-default.preset
#     │           └── 99-default-disable.preset
#     └── share
#         ├── doc
#         │   ├── redhat-release -> redos-release
#         │   └── redos-release
#         │       ├── Contributors
#         │       └── GPL
#         ├── redhat-release -> redos-release
#         └── redos-release
#             ├── EULA
#             └── EULA_ru
RUN rpm --root=$CHROOT_DIR --rebuilddb
RUN rpm --root=$CHROOT_DIR --nodeps --quiet -i $CHROOT_DIR/redos-release.rpm
RUN cp $CHROOT_DIR/etc/pki/rpm-gpg/RPM-GPG-KEY-RED-SOFT /etc/pki/rpm-gpg/RPM-GPG-KEY-RED-SOFT

# Setup the backports repository since python3-gevent package is broken
# on RedOS 7.3 (segfaults).
RUN curl $BACKPORTS_REPO_FILE \
    --fail \
    --silent \
    --show-error \
    --retry 5 \
    --retry-delay 5 \
    --output $CHROOT_DIR/etc/yum.repos.d/$(basename $BACKPORTS_REPO_FILE)

# Install base toolset for building and packaging projects.
#
# The chroot environment has only RedOS repository, so all
# installed packages are from RedOS, not from the builder image.
RUN yum -y --installroot=$CHROOT_DIR update
RUN yum -y --installroot=$CHROOT_DIR groupinstall 'Development Tools'
RUN yum -y --installroot=$CHROOT_DIR install \
    yum \
    rpm-devel \
    rpmdevtools \
    rpm-build \
    ccache \
    git \
    sudo \
    dnf-utils

# Enable sudo without tty.
RUN sed -i -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' $CHROOT_DIR/etc/sudoers

# Clear YUM cache.
RUN rm -rf $CHROOT_DIR/var/cache/yum

FROM scratch

WORKDIR /

COPY --from=prepare /chroot/. /

CMD ["/bin/bash"]
