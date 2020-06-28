#!/bin/sh
set -e

if [ -d "/tmp/.aws" ]; then
    cp -R /tmp/.aws /root/.aws
fi

exec "$@"