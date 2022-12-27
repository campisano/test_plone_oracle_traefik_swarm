#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

exec common/ci/delivery.sh \
     backend \
     plone/plone-backend:6.0.0.2 \
     plone-backend-oracle
