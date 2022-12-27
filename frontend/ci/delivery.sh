#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

exec common/ci/delivery.sh \
     frontend \
     plone/plone-frontend:16.5.0 \
     plone-frontend-addons
