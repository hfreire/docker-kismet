#!/usr/bin/env bash
set -e

if [ "${1:0:1}" = '-' ]; then
  set -- kismet "$@"
fi

exec gosu kismet "$@"
