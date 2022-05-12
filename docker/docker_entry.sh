#! /bin/sh

set -e -x

if [ ! -d "/root/config" ]; then
    mkdir /root/config
fi

if [ ! -f "/root/config/config.yaml" ]; then
    cp /root/judge-core/config-example.yaml /root/config/config.yaml
fi

if [ X"${1}" = X"primary" ]; then
    cd /root/judge-core
    exec pnpm start
else
    exec "${@}"
fi
