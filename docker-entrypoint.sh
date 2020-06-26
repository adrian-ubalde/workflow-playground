#!/bin/sh
set -e

cp -R /tmp/.aws /root/.aws
chmod 700 /root/.aws
chmod 600 /root/.aws/credentials
# chmod 600 /root/.aws/config

exec "$@"