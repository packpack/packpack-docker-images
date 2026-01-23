ARG ARCH=
FROM ${ARCH}ubuntu:oracular
MAINTAINER Alexander Turenko <alexander.turenko@tarantool.org>

# Fix missing locales
ENV LC_ALL="C.UTF-8" LANG="C.UTF-8"

# Skip interactive post-install scripts
ENV DEBIAN_FRONTEND=noninteractive

# Don't install recommends
RUN echo 'apt::install-recommends "false";' > /etc/apt/apt.conf.d/00recommends

# Enable extra repositories and base toolset
RUN apt-get update && apt-get install -y --force-yes \
    apt-transport-https \
    curl \
    wget \
    gnupg \
    ca-certificates \
    software-properties-common \
    sudo \
    git \
    build-essential \
    cmake \
    gdb \
    ccache \
    devscripts \
    debhelper \
    cdbs \
    fakeroot \
    lintian \
    equivs \
    rpm \
    alien \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable sudo without password
RUN echo '%adm ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Drop a user and a group named 'ubuntu'.
#
# packpack has a userwrapper.sh script that creates a user in the
# container whose UID and GID are the same as ones of a user of
# the host machine that calls packpack. All the actions inside the
# container are performed using this user, so files that are
# created in a volume can be read by the user of the host machine.
#
# A typical host machine user has UID = 1000. It means that the
# userwrapper.sh script attempts to create a user in a container
# and fails, because a user with this UID exists.
#
# Since the UID = 1000 and GID = 1000 are so typical, let's drop
# the container's user with UID = 1000 and GID = 1000 to let the
# userwrapper.sh script succeed on this image.
#
# See also:
#
# * https://bugs.launchpad.net/cloud-images/+bug/2005129
# * https://github.com/packpack/packpack/issues/127
#
# The following message is expected and OK:
#
# > userdel: ubuntu mail spool (/var/mail/ubuntu) not found
RUN userdel -r ubuntu
