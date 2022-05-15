#! /bin/sh

set -e -x

if [ ! -d "/root/config" ]; then
    mkdir /root/config
fi

if [ ! -f "/root/config/config.yaml" ]; then
    cp /root/judge-core/config-example.yaml /root/config/config.yaml
fi

mount --bind /opt/rootfs /opt/rootfs

mount_tmpfs() {
    path="${1}"
    size="${2}"

    if [ -z "${size}" ]; then
        size=512M
    fi

    if [ ! -d "${path}" ]; then
        mkdir -p "${path}"
    fi

    findmnt "${path}" -t tmpfs || mount -t tmpfs -o size="${size}" tmpfs "${path}"
}

if [ -n "${MOUNT_PATH_LIST}" ]; then
    for path in ${MOUNT_PATH_LIST}; do
        mount_tmpfs "${path}" "${MOUNT_TMPFS_SIZE}"
    done
fi

if [ X"${1}" = X"primary" ]; then
    cd /root/judge-core
    exec pnpm start
else
    exec "${@}"
fi
