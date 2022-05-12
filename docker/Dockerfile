FROM node:16 AS build

USER root
WORKDIR /root

ARG ROOTFS_TARGET_NAME="sandbox-rootfs.tar.zst"

COPY ./ ./judge-core
COPY --from=judgeq/sandbox-rootfs:ubuntu20.04 /root/${ROOTFS_TARGET_NAME} ./

ENV DEBIAN_FRONTEND=noninteractive
ENV LLVM_VERSION=14

RUN apt update \
    && apt install --no-install-recommends --no-install-suggests -y \
    zstd \
    wget \
    libfmt-dev \
    && wget https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \\
    && ./llvm.sh ${LLVM_VERSION} all \\
    && rm llvm.sh \
    && cd judge-core \
    && npm i -g pnpm \
    && CC=clang CXX=clang++ CXXFLAGS="-stdlib=libc++" LDFLAGS="-stdlib=libc++ -lc++abi -fuse-ld=lld" pnpm i \
    && cp ./docker/docker_entry.sh /root/docker_entry.sh \
    && tar --use-compress-program=unzstd -xvf /root/${ROOTFS_TARGET_NAME} -C /opt/ \
    && rm -rf /root/${ROOTFS_TARGET_NAME}

FROM node:16-alpine

USER root
WORKDIR /root

COPY --from=build /root ./
COPY --from=build /opt/rootfs /opt/rootfs

ENV DEBIAN_FRONTEND=noninteractive

ENV JUDGEQ_JUDGE_CONFIG_FILE=/root/config/config.yaml

RUN chmod +x /root/docker_entry.sh \
    && npm i -g pnpm \
    && apk add tzdata \
    && apk add arch-install-scripts

ENTRYPOINT ["/root/docker_entry.sh"]

CMD ["primary"]
