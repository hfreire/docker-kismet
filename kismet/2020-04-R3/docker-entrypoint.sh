#!/usr/bin/env bash

set -eu

if [ -z "${1:-}" ] || [ "${1:0:1}" = "-" ]; then
  set -- kismet "$@"
fi

exec gosu kismet "$@"
