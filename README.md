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
