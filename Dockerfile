FROM alpine:edge
ARG ETCD_VERSION=3.3.9
ENV CLUSTER_SIZE 3
ENV ETCDCTL_API 3
ENV ETCD_HEARTBEAT_INTERVAL 10 
ENV ETCD_ELECTION_TIMEOUT 100
ADD run.sh /bin/
RUN apk add --update ca-certificates curl bash tar bind-tools && \
    apk add tini --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted && \
    curl -L https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz -o etcd.tar.gz && \
    tar xzf etcd.tar.gz && \
    mv etcd-*/etcd /etcd-*/etcdctl /bin/ && \
    rm -rf etcd.tar.gz etcd-*
VOLUME      /data
EXPOSE      2379 2380 4001 7001
#HEALTHCHECK --interval=3s --retries=3 --timeout=1s --start-period=120s CMD /bin/etcdctl --endpoints=http://127.0.0.1:2379 get ping | grep -q pong
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/run.sh"]
