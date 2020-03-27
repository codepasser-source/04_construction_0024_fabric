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
# fabric-docker-up.sh
docker-compose -f docker-compose.yaml up -d
```

> 创建通道

```shell script
cli-peer-channel.sh
# 创建通道
peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
# 移动channel block 文件提供其他节点加入复用
mv $CHANNEL_NAME.block ./channel-artifacts/

# 加入通道
## Channel join peer0.org1.example.com:7051
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
## Channel join peer1.org1.example.com:8051
export CORE_PEER_ADDRESS=peer1.org1.example.com:8051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
## Channel join peer0.org2.example.com:9051
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
## Channel join peer1.org2.example.com:10051
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

# 更新锚节点
## Anchors change peer0.org1.example.com:7051
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
## Anchors change peer0.org1.example.com:7051
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```

> 服务关闭

```shell script
# fabric-docker-down.sh
docker-compose -f docker-compose.yaml down
```
