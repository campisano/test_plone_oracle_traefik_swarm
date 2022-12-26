#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

export DOCKER_BACKEND_IMAGE_FROM=plone/plone-backend:6.0.0.2
export PROJECT_NAME=plone-backend-oracle
export RELEASE_TAG=${PROJECT_NAME}_${CI_COMMIT_REF_NAME}
export RELEASE_TAG_LATEST=${PROJECT_NAME}_latest

echo "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USERNAME}" --password-stdin
docker pull "${DOCKER_REPOSITORY}:${RELEASE_TAG}" &> /dev/null && echo "ERROR: docker image \"${DOCKER_REPOSITORY}:${RELEASE_TAG}\" already exists" >&2 && exit 1

# from https://docs.docker.com/build/building/multi-platform/#building-multi-platform-images
docker pull tonistiigi/binfmt:latest
docker run --privileged --rm tonistiigi/binfmt --uninstall qemu-*
docker run --privileged --rm tonistiigi/binfmt --install arm64
docker buildx ls
docker buildx create --name currentbuilder --driver docker-container --bootstrap --use
docker buildx inspect
docker buildx build --no-cache --force-rm --tag "${DOCKER_REPOSITORY}:${RELEASE_TAG}" \
       --platform linux/amd64,linux/arm64 \
       --build-arg "FROM_IMAGE=${DOCKER_BACKEND_IMAGE_FROM=}" \
       --file backend/Dockerfile --push backend
