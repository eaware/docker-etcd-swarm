FROM alpine:edge
ARG ETCD_VERSION=2.3.8
ENV CLUSTER_SIZE 3
ADD run.sh /bin/run.sh
RUN apk add --update ca-certificates curl bash openssl tar && \
    apk add tini --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted && \
    curl -L https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz -o etcd.tar.gz && \
    tar xzf etcd.tar.gz && \
    mv etcd-*/etcd /etcd-*/etcdctl /bin/ && \
    /bin/etcd --version && \
    rm -rf etcd.tar.gz etcd-*
VOLUME      /data
EXPOSE      2379 2380 4001 7001
HEALTHCHECK --interval=3s --retries=3 --timeout=1s CMD /bin/etcdctl --endpoints=http://127.0.0.1:2379 get ping | grep -q pong
ENTRYPOINT ["/sbin/tini", "--", "/bin/run.sh"]