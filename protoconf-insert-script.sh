#!/bin/bash
set -e
set -x
echo "VARS: $*"
STORE_TYPE=${STORE_TYPE:-consul}
STORE_ADDRESS=${STORE_ADDRESS:-localhost:8500}
PREFIX=${PREFIX:-"/"}
BULK_SIZE=${BULK_SIZE:-10}
export GIT_TERMINAL_PROMPT=0
mkdir -p /tmp/repo
git clone ${GIT_REPO} /tmp/repo || cd /tmp/repo
cd /tmp/repo
git fetch -a
git reset --hard ${AFTER_COMMIT}
CONFIGS_TO_INSERT=$(find  materialized_config/ -type  f | sed -e 's/^materialized_config\/\(.*\)/\1/')
if [ -z "${CONFIGS_TO_INSERT}" ]; then
    exit 0
fi
echo ${CONFIGS_TO_INSERT} | xargs -n${BULK_SIZE} \
    protoconf insert \
        -store "${STORE_TYPE}" \
        -store-address "${STORE_ADDRESS}" \
        -prefix "${PREFIX}" \
        .
