FROM alpine:3.13 AS builder

ARG ETCD_VER=v3.4.16
# choose either URL
ARG GOOGLE_URL=https://storage.googleapis.com/etcd
ARG GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
ARG DOWNLOAD_URL=${GOOGLE_URL}

WORKDIR /bin
RUN apk add --update ca-certificates curl tar && \
    curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz | tar xzf - --strip-components 1 --wildcards etcd-*/etcd etcd-*/etcdctl

FROM alpine:3.13
RUN apk add --update bind-tools bash tini
ADD run.sh /bin/

ENV CLUSTER_SIZE 3
ENV ETCDCTL_API 3
ENV ETCD_HEARTBEAT_INTERVAL 10 
ENV ETCD_ELECTION_TIMEOUT 100

COPY --from=builder /bin/etcd /bin/etcdctl /bin/
RUN chmod 700 /data
VOLUME      /data
EXPOSE      2379 2380 4001 7001
HEALTHCHECK --interval=3s --retries=3 --timeout=1s --start-period=120s CMD /bin/etcdctl --endpoints=http://127.0.0.1:2379 get ping | grep -q pong
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/run.sh"]
