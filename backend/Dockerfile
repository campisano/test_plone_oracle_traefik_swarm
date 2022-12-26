ARG FROM_IMAGE
FROM $FROM_IMAGE
ARG TARGETARCH

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

# Oracle drivers

RUN test "$TARGETARCH" = "amd64" || exit 0 \
    && BASEURL="https://download.oracle.com/otn_software/linux/instantclient/218000" \
    && mkdir -p /opt/oracle && cd /opt/oracle \
    && curl -sS "${BASEURL}/instantclient-basiclite-linux.x64-21.8.0.0.0dbru.zip" -o tmp.zip && unzip -q tmp.zip && rm -f tmp.zip \
    && curl -sS "${BASEURL}/instantclient-sqlplus-linux.x64-21.8.0.0.0dbru.zip" -o tmp.zip && unzip -q tmp.zip && rm -f tmp.zip \
    && curl -sS "${BASEURL}/instantclient-sdk-linux.x64-21.8.0.0.0dbru.zip" -o tmp.zip && unzip -q tmp.zip && rm -f tmp.zip \
    && mv /opt/oracle/instantclient_* /opt/oracle/instantclient

RUN test "$TARGETARCH" = "arm64" || exit 0 \
    && BASEURL="https://download.oracle.com/otn_software/linux/instantclient/191000" \
    && mkdir -p /opt/oracle && cd /opt/oracle \
    && curl -sS "${BASEURL}/instantclient-basic-linux.arm64-19.10.0.0.0dbru.zip" -o tmp.zip && unzip -q tmp.zip && rm -f tmp.zip \
    && curl -sS "${BASEURL}/instantclient-sqlplus-linux.arm64-19.10.0.0.0dbru.zip" -o tmp.zip && unzip -q tmp.zip && rm -f tmp.zip \
    && curl -sS "${BASEURL}/instantclient-sdk-linux.arm64-19.10.0.0.0dbru.zip" -o tmp.zip && unzip -q tmp.zip && rm -f tmp.zip \
    && mv /opt/oracle/instantclient_* /opt/oracle/instantclient

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient
ENV TNS_ADMIN=/opt/oracle/instantclient/network/admin

# RelStorage
# from https://relstorage.readthedocs.io/en/latest/install.html
# and https://cx-oracle.readthedocs.io/en/latest/user_guide/installation.html
# and https://6.docs.plone.org/install/containers/images/backend.html?highlight=relstorage%20conf#relational-database-variables
USER plone
RUN bash -c 'source bin/activate \
    && pip install --progress-bar off --no-color --no-input --no-cache-dir --upgrade pip setuptools wheel \
    && pip install --progress-bar off --no-color --no-input --no-cache-dir "cx_Oracle" || true \
    && pip install --progress-bar off --no-color --no-input --no-cache-dir "RelStorage[oracle]"'

USER root

COPY cfg/relstorage.conf etc/relstorage.conf
COPY scripts scripts
RUN chmod 0644 etc/relstorage.conf && chmod -R 0755 scripts

ENTRYPOINT ["/app/scripts/entrypoints.sh", "/app/docker-entrypoint.sh"]
CMD ["start"]
