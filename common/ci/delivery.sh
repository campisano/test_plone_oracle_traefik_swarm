#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

if test $# -ne 3
then echo "Usage: $0  <build_folder> <docker_base_image> <build_name>" 1>&2; exit 1
fi

BUILD_FOLDER=$1
DOCKER_BASE_IMAGE=$2
BUILD_NAME=$3



RELEASE_TAG=${BUILD_NAME}_${CI_COMMIT_REF_NAME}

echo "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USERNAME}" --password-stdin
docker pull "${DOCKER_REPOSITORY}:${RELEASE_TAG}" &> /dev/null && echo "ERROR: docker image \"${DOCKER_REPOSITORY}:${RELEASE_TAG}\" already exists" >&2 && exit 1



# from https://docs.docker.com/build/building/multi-platform/#building-multi-platform-images
docker pull tonistiigi/binfmt:latest
docker run --privileged --rm tonistiigi/binfmt --uninstall qemu-*
docker run --privileged --rm tonistiigi/binfmt --install arm64
docker buildx ls
docker buildx create --name currentbuilder --driver docker-container --bootstrap --use
docker buildx inspect
docker buildx build --push --platform linux/amd64,linux/arm64 \
       --build-arg "DOCKER_BASE_IMAGE=${DOCKER_BASE_IMAGE=}" \
       --tag "${DOCKER_REPOSITORY}:${RELEASE_TAG}" \
       --file "${BUILD_FOLDER}"/Dockerfile "${BUILD_FOLDER}"
