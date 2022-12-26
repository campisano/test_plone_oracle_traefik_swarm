#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

fn_grant_var()
{
    test ! -z ${!1+unset} || (echo "Missing env var $1." >&2; exit -1)
}

for SECRET_FILE in $(test -d /run/secrets && find /run/secrets -maxdepth 1 -type f); do
    VAR=$(basename "$SECRET_FILE")
    VAL=$(cat "$SECRET_FILE")
    export "$VAR"="$VAL"
    unset VAR
    unset VAL
done

fn_grant_var RELSTORAGE_ORA_USR
fn_grant_var RELSTORAGE_ORA_PWD
fn_grant_var RELSTORAGE_DSN
fn_grant_var TNS_ADMIN_FILEDATA



echo "$TNS_ADMIN_FILEDATA" | base64 -d | tar -xzf - -C /opt/oracle/instantclient/network/admin
unset TNS_ADMIN_FILEDATA
chown -R root:root /opt/oracle/instantclient/network/admin/*
chmod 644 /opt/oracle/instantclient/network/admin/*



exec $@
