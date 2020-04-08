## Fabric - 开发示例 0007

### 前言

> 教程参考

- [`first-network`](https://hyperledger-fabric.readthedocs.io/zh_CN/release-1.4/build_network.html#)
 
#### 环境准备 

> 00.fabric-environment.md
> 01.fabric-server-build.md
> 02.fabric-install.md

#### 示例说明

> 链码语言

* `go`

> 状态存储

* `couchdb`

    * `[couchdb utils](http://172.16.20.163:5984/_utils)`
    * `[couchdb utils](http://172.16.20.163:6984/_utils)`
    * `[couchdb utils](http://172.16.20.163:7984/_utils)`
    * `[couchdb utils](http://172.16.20.163:8984/_utils)`

> 排序服务

* `kafka`

```shell script
# kafka操作
docker exec -it kafka.example.com bash
cd /opt/kafka/bin
# 查看kafka topic 列表
./kafka-topics.sh --zookeeper zookeeper.example.com:2181 --list

# 查看kafka topic 明细
./kafka-topics.sh --zookeeper zookeeper.example.com:2181 --describe --topic fabric-course
./kafka-topics.sh --zookeeper zookeeper.example.com:2181 --describe --topic course-sys-channel

# 查看kafka 日志
docker logs -f kafka.example.com
```
> 组织 

* `Org1`
* `Org2`
* `Order`

> 节点 

* `peer0.org1.example.com`
* `peer1.org1.example.com`
* `peer0.org2.example.com`
* `peer1.org2.example.com`

> 排序节点 

* `orderer.example.com`

> CA

* `ca.org1.example.com`
* `ca.org2.example.com`

> 集群环境

* docker swarm overlay : fabric_course

> 应用程序

* fabcar

#### 构建过程

> orderer

- 生成构建

    * crypto
    * configtx [kafka]
    * cpp

- 启动order节点

