#! /bin/bash

apt update

apt install --no-install-recommends --no-install-suggests -y \
    zstd \
    wget \
    sudo \
    libfmt-dev \
    lsb-release \
    software-properties-common
