
## 创建overlay网络

> 初始化docker集群管理节点 

```shell script
# 管理节点操作
docker swarm init --advertise-addr 172.16.20.163
```

```shell script
# 工作节点操作
# 查看工作加入token
docker swarm join-token worker
docker swarm join --token SWMTKN-1-2kke4rbao633z9d554cofss6jvvb8klbvbwq18rn8abdt1xvmg-19lovdl5t10abumpdv3kfyb9q 172.16.20.163:2377
# 查看管理节点身份加入token
docker swarm join-token manager
docker swarm join --token SWMTKN-1-2kke4rbao633z9d554cofss6jvvb8klbvbwq18rn8abdt1xvmg-apg5k84m8w81mts8qfat32hm2 172.16.20.163:2377
```

```shell script
docker node ls
qje9snr2asbfhcivc611egycl *   orderer.codepasser.com   Ready               Active              Leader              19.03.8
mdp8sv9xwxbex119cvy59iiws     org1.codepasser.com      Ready               Active                                  19.03.8
3zwo37g0qo8wsrslj95ndnjxc     org2.codepasser.com      Ready               Active                                  19.03.8
```

> 创建overlay网络(管理节点操作)

```shell script
docker network create --driver overlay fabric_course
docker network create --driver overlay --attachable fabric_course
docker network create --driver overlay --attachable --opt encrypted fabric_course
```

> 确认网络

```shell script
# 管理节点
docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
c47e5e2d6047        bridge              bridge              local
3eb320cdf258        docker_gwbridge     bridge              local
aa11911310f3        host                host                local
i4wkmldt5cdr        ingress             overlay             swarm
ab566621386b        none                null                local
tz29whxdqr7p        fabric_course        overlay             swarm
# 工作节点 暂时看不到fabric_course网络,当容器实例应用负载时才可见
NETWORK ID          NAME                DRIVER              SCOPE
19c6b8a93532        bridge              bridge              local
19d7d62ca00e        docker_gwbridge     bridge              local
c788d25481a8        host                host                local
i4wkmldt5cdr        ingress             overlay             swarm
2e119583b9e7        none                null                local
tz29whxdqr7p        fabric_course        overlay             swarm
```
- [注意]

    * 关闭防火墙
    * 手动关闭后需要冲洗docker服务 systemctl restart docker.service 


> 验证网络

```shell script
docker pull busybox

# 管理节点启动(172.16.20.163)
docker run -itd \
        --name c1 \
        --network fabric_course \
        busybox

# 工作节点启动(172.16.20.164)
docker run -itd \
        --name c2 \
        --network fabric_course \
        busybox

# 工作节点启动(172.16.20.165)
docker run -itd \
        --name c3 \
        --network fabric_course \
        busybox

# 查看启动结果
docker ps -a

# 进入容器
docker exec c1 ping -c 2 c2

docker exec c2 ping -c 2 c1

docker exec c3 ping -c 2 c1
```

> 环境清理

```shell script
docker stop c1
docker rm c1
docker swarm leave -f
docker network rm docker_gwbridge
docker network ls

docker stop c2
docker rm c2
docker swarm leave
docker network rm docker_gwbridge
docker network ls


docker stop c3
docker rm c3
docker swarm leave
docker network rm docker_gwbridge
docker network ls
```
