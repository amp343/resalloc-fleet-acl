FROM alpine:3.2

#
# This is the Dockerfile that builds amp343/alpine-ruby
# which is used as the base for Dockerfile.fleet-acl
#

ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base libffi-dev zlib-dev libxml2-dev libxslt-dev tzdata sqlite-dev yaml-dev
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler ruby-sqlite

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/*

WORKDIR /src

ENTRYPOINT ping 8.8.8.8
