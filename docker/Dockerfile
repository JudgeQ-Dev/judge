FROM node:16 AS build

USER root
WORKDIR /root

ARG ROOTFS_TARGET_NAME="sandbox-rootfs.tar.zst"

COPY ./ ./judge-core
COPY --from=judgeq/sandbox-rootfs:ubuntu20.04 /root/${ROOTFS_TARGET_NAME} ./

ENV DEBIAN_FRONTEND=noninteractive

RUN cd judge-core \
    && npm i -g pnpm \
    && pnpm i \
    && cp ./docker/docker_entry.sh /root/docker_entry.sh \
    && apt install --no-install-recommends --no-install-suggests -y zstd \
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
