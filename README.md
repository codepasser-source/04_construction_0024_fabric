### 04_construction_0024_fabric ###

## Fabric - 开发过程

### 前言

#### 环境准备 

> 00.fabric-environment.md
> 01.fabric-server-build.md
> 02.fabric-install.md

#### 引言

> 结构目录参考first-network

> [博客参考](https://blog.csdn.net/zhongliwen1981/article/details/104273977)

### 过程纪要

#### 1.0 网络结构

|   组织   |   组织标识   |   组织ID   |
|   ----  |    ----     |   ----   |
|  GO学科     |   OrgGo     |   OrgGoMSP     |
|  JAVA学科   |   OrgJava   |   OrgJavaMSP   |

- MSP(Membership service provider)是一个提供虚拟成员操作的管理框架的组件。每一个组织、节点、用户都有一个MSP账号。

#### 1.1 生成证书

> cryptogen配置文件

```
crypto-config.yaml
```

> 生成证书

```shell script
# fabric-cryptogen.sh
cryptogen generate --config=crypto-config.yaml
```

#### 1.2 证书结构

```
cd crypto-config

├── ordererOrganizations
│   └── example.com
│       ├── ca
│       ├── msp
│       ├── orderers
│       ├── tlsca
│       └── users
└── peerOrganizations
    ├── orggo.example.com
    │   ├── ca
    │   ├── msp
    │   ├── peers
    │   ├── tlsca
    │   └── users
    └── orgjava.example.com
        ├── ca
        ├── msp
        ├── peers
        ├── tlsca
        └── users
```

#### 1.3 网络构建配置(组织\联盟\生成创世块文件\通道文件)

> configtxgen配置文件

```
configtx.yaml
```

> 生成创世区块文件

```shell script
# fabric-configtxgen-genesis.sh
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block -channelID course-channel
```
```shell script
# TODO kafka
configtxgen -profile SampleDevModeKafka -outputBlock ./channel-artifacts/genesis.block -channelID course-channel
# TODO Raft
configtxgen -profile SampleMultiNodeEtcdRaft -outputBlock ./channel-artifacts/genesis.block -channelID course-channel
```

> 生成通道文件
```shell script
# fabric-configtxgen-channel.sh
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID course-channel
```

#### 1.4 配置网络启动

> docker-compose 配置文件
```
docker-compose.yaml
```

> 启动

```shell script
# fabric-docker-up.sh
docker-compose -f docker-compose.yml up -d
```

> 停止

```shell script
# fabric-docker-down.sh
docker-compose -f docker-compose.yml down
```

#### 1.5 创建通道和加入通道

> 进入cli(fabric-tool docker实例)
```shell script
docker exec -it cli bash
```

> 创建通道
```shell script
peer channel create -o orderer.example.com:7050 -c course-channel -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```

> 加入通道

- peer0.orggo.example.com节点
```shell script
export CORE_PEER_ADDRESS=peer0.orggo.example.com:7051 
export CORE_PEER_LOCALMSPID=OrgGoMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orggo.example.com/peers/peer0.orggo.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orggo.example.com/peers/peer0.orggo.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orggo.example.com/peers/peer0.orggo.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orggo.example.com/users/Admin@orggo.example.com/msp
peer channel join -b ./channel-artifacts/course-channel.block
```

- peer1.orggo.example.com节点
```shell script
export CORE_PEER_ADDRESS=peer1.orggo.example.com:7051
export CORE_PEER_LOCALMSPID=OrgGoMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orggo.example.com/peers/peer1.orggo.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orggo.example.com/peers/peer1.orggo.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orggo.example.com/peers/peer1.orggo.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orggo.example.com/users/Admin@orggo.example.com/msp

peer channel join -b ./channel-artifacts/course-channel.block
```

- peer0.orgjava.example.com节点
```shell script
export CORE_PEER_ADDRESS=peer0.orgjava.example.com:7051
export CORE_PEER_LOCALMSPID=OrgJavaMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orgjava.example.com/peers/peer0.orgjava.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orgjava.example.com/peers/peer0.orgjava.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orgjava.example.com/peers/peer0.orgjava.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orgjava.example.com/users/Admin@orgjava.example.com/msp

peer channel join -b ./channel-artifacts/course-channel.block
```

- peer1.orgjava.example.com节点
```shell script
export CORE_PEER_ADDRESS=peer1.orgjava.example.com:7051
export CORE_PEER_LOCALMSPID=OrgJavaMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orgjava.example.com/peers/peer1.orgjava.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orgjava.example.com/peers/peer1.orgjava.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orgjava.example.com/peers/peer1.orgjava.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orgjava.example.com/users/Admin@orgjava.example.com/msp

peer channel join -b ./channel-artifacts/course-channel.block
```
