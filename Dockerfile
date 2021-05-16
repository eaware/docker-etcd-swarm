FROM alpine
ENV CLUSTER_SIZE 3
ENV ETCDCTL_API 3
ENV ETCD_HEARTBEAT_INTERVAL 10 
ENV ETCD_ELECTION_TIMEOUT 100

ARG ETCD_VER=v3.4.16
# choose either URL
ARG GOOGLE_URL=https://storage.googleapis.com/etcd
ARG GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
ARG DOWNLOAD_URL=${GOOGLE_URL}

ADD run.sh /bin/
RUN apk add --update ca-certificates curl bash tar bind-tools tini && \
    curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o etcd.tar.gz && \
    tar xzf etcd.tar.gz && \
    mv etcd-*/etcd /etcd-*/etcdctl /bin/ && \
    rm -rf etcd.tar.gz etcd-*
VOLUME      /data
EXPOSE      2379 2380 4001 7001
HEALTHCHECK --interval=3s --retries=3 --timeout=1s --start-period=120s CMD /bin/etcdctl --endpoints=http://127.0.0.1:2379 get ping | grep -q pong
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/run.sh"]
