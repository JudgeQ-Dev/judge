#! /bin/bash

apt update

apt install --no-install-recommends --no-install-suggests -y \
    zstd \
    wget \
    libfmt-dev \
    lsb-release \
    software-properties-common
