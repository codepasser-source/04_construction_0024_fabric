### 04_construction_0024_fabric ###

## Fabric - 开发过程

### 前言

#### 环境准备 

> 00.fabric-environment.md
> 01.fabric-server-build.md
> 02.fabric-install.md

#### 引言

> 结构目录参考first-network

### 过程纪要

#### 生成构件

> 生成证书

- 脚本

```shell script
# fabric-cryptogen-generate.sh
cryptogen generate --config=./crypto-config.yaml
```

- 生成结果

```text
├── crypto-config
│   ├── ordererOrganizations
│   │   └── example.com
│   │       ├── ca
│   │       ├── msp
│   │       ├── orderers
│   │       ├── tlsca
│   │       └── users
│   └── peerOrganizations
│       ├── org1.example.com
│       │   ├── ca
│       │   ├── msp
│       │   ├── peers
│       │   ├── tlsca
│       │   └── users
│       └── org2.example.com
│           ├── ca
│           ├── msp
│           ├── peers
│           ├── tlsca
│           └── users
```

> 生成创世区块

- 生成 Solo 排序服务的创世区块(默认排序服务实现)

```shell script
# fabric-configtx-genesis-solo.sh
configtxgen -profile TwoOrgsOrdererGenesis -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
```

- 生成 Raft 排序服务的创世区块

```shell script
# fabric-configtx-genesis-raft.sh
configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
```

```shell script
# fabric-configtx-genesis-kafka.sh
configtxgen -profile SampleDevModeKafka -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
```

> 生成通道配置交易

- 生成通道配置

```shell script
# fabric-configtx-channel.sh
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID fabric-course
```

- 生成锚节点定义

```shell script
# fabric-configtx-anchors.sh
# Org1 锚点定义
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID fabric-course -asOrg Org1MSP
# Org2 锚点定义
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID fabric-course -asOrg Org2MSP
```

#### 启动网络

> 服务启动

```shell script
docker-compose -f docker-compose.yaml up -d
```

> 创建通道

- 创建通道

- 加入通道

- 更新锚节点
