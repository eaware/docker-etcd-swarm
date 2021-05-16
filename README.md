version: "3.8"

services:
  etcd:
    image: etcdtest
    ports: 
      - 2379-2380:2379-2380
    deploy:
      replicas: 3
      placement:
        constraints: [node.role ==  manager]
      update_config:
        parallelism: 1
        failure_action: rollback
        delay: 30s
```

Start the stack
```
docker stack deploy -c docker-stack.yml etcd
``` 

