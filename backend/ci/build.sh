#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

export DOCKER_BACKEND_IMAGE_FROM=plone/plone-backend:6.0.0.2
TARGETARCH=$(uname -m)

if test "$TARGETARCH" = 'x86_64'
then export TARGETARCH="amd64"
elif test "$TARGETARCH" = 'aarch64'
then export TARGETARCH="arm64"
else echo unkown arch "$TARGETARCH" 1>&2; exit 1
fi



docker build --no-cache --force-rm \
       --build-arg "FROM_IMAGE=${DOCKER_BACKEND_IMAGE_FROM=}" \
       --build-arg "TARGETARCH=${TARGETARCH=}" \
       --tag plone-backend:local \
       --file backend/Dockerfile backend
