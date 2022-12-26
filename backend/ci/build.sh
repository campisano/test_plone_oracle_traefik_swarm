#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

export DOCKER_BACKEND_IMAGE_FROM=plone/plone-backend:6.0.0.2
TARGETOS=$(uname -o)
TARGETARCH=$(uname -m)

if test "$TARGETOS" = 'GNU/Linux' -o "$TARGETOS" = 'Linux'
then export TARGETOS="linux"
else echo unkown OS "$TARGETOS" 1>&2; exit 1
fi

if test "$TARGETARCH" = 'x86_64'
then export TARGETARCH="amd64"
elif test "$TARGETARCH" = 'aarch64'
then export TARGETARCH="arm64"
else echo unkown arch "$TARGETARCH" 1>&2; exit 1
fi



docker build --no-cache --force-rm --tag plone-backend:local \
       --build-arg "FROM_IMAGE=${DOCKER_BACKEND_IMAGE_FROM=}" \
       --build-arg "TARGETOS=${TARGETOS=}" \
       --build-arg "TARGETARCH=${TARGETARCH=}" \
       --file backend/Dockerfile backend
