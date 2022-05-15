#! /bin/sh

set -e -x

if [ ! -d "/root/config" ]; then
    mkdir /root/config
fi

if [ ! -f "/root/config/config.yaml" ]; then
    cp /root/judge-core/config-example.yaml /root/config/config.yaml
fi

mount_tmpfs() {
    path="${1}"
    size="${2}"

    if [ -z "${size}" ]; then
        size=512M
    fi

    findmnt "${path}" -t tmpfs || mount -t tmpfs -o size="${size}" tmpfs "${path}"
}

mount --bind /opt/rootfs /opt/rootfs

if [ -n "${MOUNT_COMMAND}" ]; then
    "${MOUNT_COMMAND}"
fi

if [ X"${1}" = X"primary" ]; then
    cd /root/judge-core
    exec pnpm start
else
    exec "${@}"
fi
