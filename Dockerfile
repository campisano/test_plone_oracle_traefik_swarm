ARG FROM_IMAGE
FROM $FROM_IMAGE AS linux-common-img

RUN export DEBIAN_FRONTEND=noninteractive \
    && sed -i -E 's/ main$/ main contrib non-free/g' /etc/apt/sources.list \
    && apt-get -qq -y update \
    && apt-get -qq -y install --no-install-recommends apt-utils > /dev/null

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -qq -y install ca-certificates libaio1 curl unzip > /dev/null

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -qq -y install gcc g++ make libc-dev > /dev/null

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* /usr/share/man/*





FROM --platform=linux/amd64 linux-common-img AS linux-amd64-img

# Oracle drivers

RUN mkdir -p /opt/oracle \
    && cd /opt/oracle \
    && curl -O -sS https://download.oracle.com/otn_software/linux/instantclient/218000/instantclient-basiclite-linux.x64-21.8.0.0.0dbru.zip \
    && unzip -q instantclient-basiclite-linux.x64-21.8.0.0.0dbru.zip \
    && rm -f instantclient-basiclite-linux.x64-21.8.0.0.0dbru.zip \
    && curl -O -sS https://download.oracle.com/otn_software/linux/instantclient/218000/instantclient-sqlplus-linux.x64-21.8.0.0.0dbru.zip \
    && unzip -q instantclient-sqlplus-linux.x64-21.8.0.0.0dbru.zip \
    && rm -f instantclient-sqlplus-linux.x64-21.8.0.0.0dbru.zip \
    && curl -O -sS https://download.oracle.com/otn_software/linux/instantclient/218000/instantclient-sdk-linux.x64-21.8.0.0.0dbru.zip \
    && unzip -q instantclient-sdk-linux.x64-21.8.0.0.0dbru.zip \
    && rm -f instantclient-sdk-linux.x64-21.8.0.0.0dbru.zip \
    && mv /opt/oracle/instantclient_* /opt/oracle/instantclient





ARG FROM_IMAGE
FROM --platform=linux/arm64/v8 linux-common-img AS linux-arm64-img

# Oracle drivers

RUN mkdir -p /opt/oracle \
    && cd /opt/oracle \
    && curl -O -sS https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-basic-linux.arm64-19.10.0.0.0dbru.zip \
    && unzip -q instantclient-basic-linux.arm64-19.10.0.0.0dbru.zip \
    && rm -f instantclient-basic-linux.arm64-19.10.0.0.0dbru.zip \
    && curl -O -sS https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-sqlplus-linux.arm64-19.10.0.0.0dbru.zip \
    && unzip -q instantclient-sqlplus-linux.arm64-19.10.0.0.0dbru.zip \
    && rm -f instantclient-sqlplus-linux.arm64-19.10.0.0.0dbru.zip \
    && curl -O -sS https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-sdk-linux.arm64-19.10.0.0.0dbru.zip \
    && unzip -q instantclient-sdk-linux.arm64-19.10.0.0.0dbru.zip \
    && rm -f instantclient-sdk-linux.arm64-19.10.0.0.0dbru.zip \
    && mv /opt/oracle/instantclient_* /opt/oracle/instantclient





ARG TARGETOS
ARG TARGETARCH
FROM ${TARGETOS}-${TARGETARCH}-img as final-img

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient
ENV TNS_ADMIN=/opt/oracle/instantclient/network/admin

# RelStorage
# from https://relstorage.readthedocs.io/en/latest/install.html
# and https://cx-oracle.readthedocs.io/en/latest/user_guide/installation.html
# and https://6.docs.plone.org/install/containers/images/backend.html?highlight=relstorage%20conf#relational-database-variables
USER plone
RUN bash -c 'source bin/activate \
    && pip install --progress-bar off --no-color --no-input --no-cache-dir "cx_Oracle" || true \
    && pip install --progress-bar off --no-color --no-input --no-cache-dir "RelStorage[oracle]" \
    && pip install --progress-bar off --no-color --no-input --no-cache-dir "plone.app.mosaic"'
USER root

COPY cfg/backend/relstorage.conf etc/relstorage.conf
COPY scripts scripts

ENTRYPOINT ["/app/scripts/entrypoints.sh", "/app/docker-entrypoint.sh"]
CMD ["start"]
