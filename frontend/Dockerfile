ARG DOCKER_BASE_IMAGE
FROM $DOCKER_BASE_IMAGE
ARG TARGETARCH

USER root

RUN export DEBIAN_FRONTEND=noninteractive \
    && sed -i -E 's/ main$/ main contrib non-free/g' /etc/apt/sources.list \
    && apt-get -qq -y update \
    && apt-get -qq -y install --no-install-recommends apt-utils > /dev/null

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -qq -y install ca-certificates > /dev/null

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* /usr/share/man/*

USER node
