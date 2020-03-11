# 04_construction_0024_fabric

## 示例篇 ##

## Fabric 1.1 环境部署 ##

- 获取Fabric源码
```
# 下载项目到go目录并checkout最新release-1.1分支
cd /home/go/hyperledger
# /home/go/hyperledger/fabric
git clone https://github.com/hyperledger/fabric.git
```

- 切换分支release-1.1

```
git br -a
git co -b release-1.1 remotes/origin/release-1.1
# 确认版本 1.1.0
cat scripts/bootstrap.sh |grep VERSION
```
```
  master
* release-1.1
  remotes/origin/HEAD -> origin/master
  remotes/origin/fastIdemix
  remotes/origin/feature/ca
  remotes/origin/feature/convergence
  remotes/origin/java-contract-quick-start
  remotes/origin/master
  remotes/origin/release-1.0
  remotes/origin/release-1.1
  remotes/origin/release-1.2
  remotes/origin/release-1.3
  remotes/origin/release-1.4
  remotes/origin/release-2.0
  remotes/origin/v0.6
  remotes/origin/v1.0.0-preview
```

- Fabric 1.1 docker镜像版本
```
docker pull hyperledger/fabric-baseos:x86_64-0.4.6
docker pull hyperledger/fabric-tools:x86_64-1.1.0
docker pull hyperledger/fabric-peer:x86_64-1.1.0
docker pull hyperledger/fabric-orderer:x86_64-1.1.0
docker pull hyperledger/fabric-ccenv:x86_64-1.1.0
docker pull hyperledger/fabric-javaenv:x86_64-1.1.0
docker pull hyperledger/fabric-ca:x86_64-1.1.0
docker pull hyperledger/fabric-couchdb:x86_64-0.4.6
docker pull hyperledger/fabric-kafka:x86_64-0.4.6
docker pull hyperledger/fabric-zookeeper:x86_64-0.4.6
```


## Fabric 2.0 环境部署 ##

- 切换最新分支

```
git br -a
git co -b release-2.0 remotes/origin/release-2.0
# 确认版本 2.0.0
cat scripts/bootstrap.sh |grep VERSION
```

- Fabric 2.0 docker镜像版本

```
docker pull hyperledger/fabric-baseos:2.0.0
docker pull hyperledger/fabric-tools:2.0.0
docker pull hyperledger/fabric-peer:2.0.0
docker pull hyperledger/fabric-orderer:2.0.0
docker pull hyperledger/fabric-ccenv:2.0.0
docker pull hyperledger/fabric-javaenv:2.0.0
docker pull hyperledger/fabric-ca:1.4.4
docker pull hyperledger/fabric-couchdb:0.4.18
docker pull hyperledger/fabric-kafka:0.4.18
docker pull hyperledger/fabric-zookeeper:0.4.18
```