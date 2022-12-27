#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

if test $# -ne 3
then echo "Usage: $0  <build_folder> <docker_base_image> <build_name>" 1>&2; exit 1
fi

BUILD_FOLDER=$1
DOCKER_BASE_IMAGE=$2
BUILD_NAME=$3



TARGETARCH=$(uname -m)

if test "$TARGETARCH" = 'x86_64'
then TARGETARCH="amd64"
elif test "$TARGETARCH" = 'aarch64'
then TARGETARCH="arm64"
else echo unkown arch "$TARGETARCH" 1>&2; exit 1
fi



docker build --no-cache --force-rm \
       --build-arg "DOCKER_BASE_IMAGE=${DOCKER_BASE_IMAGE=}" \
       --build-arg "TARGETARCH=${TARGETARCH=}" \
       --tag "${BUILD_NAME}":local \
       --file "${BUILD_FOLDER}"/Dockerfile "${BUILD_FOLDER}"
