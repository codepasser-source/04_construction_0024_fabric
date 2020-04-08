> 修改hostname

```shell script
hostnamectl set-hostname orderer.codepasser.com
hostnamectl set-hostname org1.codepasser.com
hostnamectl set-hostname org2.codepasser.com

vim /etc/hosts
127.0.0.1       orderer.codepasser.com
127.0.0.1       org1.codepasser.com
127.0.0.1       org2.codepasser.com

140.82.113.4    github.com
#140.82.113.3   github.com
```

> 关闭防火墙

```shell script
systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl list-unit-files |grep firewalld.service
systemctl restart docker
```

> 构建目录

```shell script
mkdir /data/software
mkdir /data/docker
mkdir -p /data/src/github.com/hyperledger
mkdir -p /data/src/github.com/codepasser-source
```

```shell script
scp go1.14.linux-amd64.tar.gz root@172.16.20.164:/data/software
scp hyperledger.tar.gz root@172.16.20.164:/data/software
scp node-v12.16.1-linux-x64.tar.xz root@172.16.20.164:/data/software

scp go1.14.linux-amd64.tar.gz root@172.16.20.165:/data/software
scp hyperledger.tar.gz root@172.16.20.165:/data/software
scp node-v12.16.1-linux-x64.tar.xz root@172.16.20.165:/data/software
```

> 处理镜像

- 注: fabric-ccenv 镜像需要修改npm源地址重新构建,之后再进行镜像导出导入.

- 导出

```shell script
docker save -o /data/docker/fabric-ccenv.tar hyperledger/fabric-ccenv:latest
docker save -o /data/docker/fabric-javaenv.tar hyperledger/fabric-javaenv:latest
docker save -o /data/docker/fabric-ca.tar hyperledger/fabric-ca:latest
docker save -o /data/docker/fabric-tools.tar hyperledger/fabric-tools:latest
docker save -o /data/docker/fabric-orderer.tar hyperledger/fabric-orderer:latest
docker save -o /data/docker/fabric-peer.tar hyperledger/fabric-peer:latest
docker save -o /data/docker/fabric-zookeeper.tar hyperledger/fabric-zookeeper:latest
docker save -o /data/docker/fabric-kafka.tar hyperledger/fabric-kafka:latest
docker save -o /data/docker/fabric-couchdb.tar hyperledger/fabric-couchdb:latest
docker save -o /data/docker/fabric-baseimage.tar hyperledger/fabric-baseimage:amd64-0.4.18
docker save -o /data/docker/fabric-baseos.tar hyperledger/fabric-baseos:amd64-0.4.18
docker save -o /data/docker/logspout.tar gliderlabs/logspout:latest
docker save -o /data/docker/busybox.tar busybox:latest
```

- 导入

```shell script
docker load -i /data/docker/fabric-ccenv.tar
docker load -i /data/docker/fabric-javaenv.tar
docker load -i /data/docker/fabric-ca.tar
docker load -i /data/docker/fabric-tools.tar
docker load -i /data/docker/fabric-orderer.tar
docker load -i /data/docker/fabric-peer.tar
docker load -i /data/docker/fabric-zookeeper.tar
docker load -i /data/docker/fabric-kafka.tar
docker load -i /data/docker/fabric-couchdb.tar
docker load -i /data/docker/fabric-baseimage.tar
docker load -i /data/docker/fabric-baseos.tar
docker load -i /data/docker/logspout.tar
docker load -i /data/docker/busybox.tar
```

> 配置环境变量

```shell script
vi /etc/profile
# GO
export GOPATH=/data
export GOBIN=/usr/local/lib/go/bin

# NODE
export NODE_HOME=/usr/local/lib/node
export NODE_BIN=$NODE_HOME/bin

# FABRIC
export FABRIC_HOME=/usr/local/lib/fabric
export FABRIC_BIN=$FABRIC_HOME/bin

# EXPORT ENV
export PATH=$PATH:$GOBIN:$NODE_BIN:$FABRIC_BIN

# EXPORT course path
export CODEPASSERSOURCE=/data/src/github.com/codepasser-source
```

> 安装node

> 安装go

> 安装fabric

```shell script
git co -b v1.4.6 v1.4.6
make release
```

```shell script
git clone git@github.com:codepasser-source/04_construction_0024_fabric.git
```
