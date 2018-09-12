# README #
This etcd cluster is designed to be run on a docker swarm. Most of the code is from [appcelerator/etcd](https://hub.docker.com/r/appcelerator/etcd/)

### How do I get set up? ###

* You can use the docker-stack.yml
```
version: "3.4"
services:
  etcd:
    image: splazit/etcd-swarm
    deploy:
      placement:
        constraints: [node.role ==  manager]
      update_config:
        parallelism: 1
        failure_action: rollback
        delay: 30s
root@do-docker900:~/docker-etcd-swarm# ls
Dockerfile  README.md  docker-stack.yml  run.sh
root@do-docker900:~/docker-etcd-swarm# vim README.md

[1]+  Stopped                 vim README.md
root@do-docker900:~/docker-etcd-swarm# cat docker-stack.yml
version: "3.4"

services:
  etcd:
    image: splazit/etcd-swarm
    deploy:
      placement:
        constraints: [node.role ==  manager]
      update_config:
        parallelism: 1
        failure_action: rollback
        delay: 30s
```
* Or run the following docker command
```
docker service create --update-delay 45s --replicas 3 --name etcd --constraint 'node.role == manager' splazit/etcd-swarm
``` 

