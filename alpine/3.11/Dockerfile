FROM alpine:3.11
MAINTAINER Konstantin Nazarov <mail@kn.am>

RUN set -x \
    && apk add --no-cache su-exec make git tar xz alpine-sdk sudo \
    && sed -i.bak -n -e '/^Defaults.*requiretty/ { s/^/# /;};/^%wheel.*ALL$/ { s/^/# / ;} ;/^#.*wheel.*NOPASSWD/ { s/^#[ ]*//;};p' /etc/sudoers
