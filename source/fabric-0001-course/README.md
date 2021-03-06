## Fabric - 开发示例 0001

### 前言

> 教程参考

- [`first-network`](https://hyperledger-fabric.readthedocs.io/zh_CN/release-1.4/build_network.html#)
 
#### 环境准备 

> 00.fabric-environment.md
> 01.fabric-server-build.md
> 02.fabric-install.md

#### 示例说明

|    链码    |    状态存储    |    排序服务    |    组织    |    节点    |    排序节点    |    CA    |    集群    |
|  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |
|    node(mycc)    |   goleveldb     |   solo     |   Org(1~2)   |   peer(0~1).org(1~2).example.com     |   orderer.example.com     |   无     |    单机环境    |

> 单机环境

#### 示例脚本

> 启动

- `fabric-bootstrap.sh`

> 通道\链码初始化操作

- `fabric-bootstrap-cli-exec.sh`

> 清理

- `fabric-bootstrap-clean.sh`

### 过程纪要

#### 生成构件

> 生成证书

- 脚本

```shell script
# fabric-bootstrap-crypto-generate.sh
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
# fabric-bootstrap-configtx-genesis-solo.sh
configtxgen -profile TwoOrgsOrdererGenesis -channelID course-sys-channel -outputBlock ./channel-artifacts/genesis.block
```

> 生成通道配置交易

- 生成通道配置

```shell script
# fabric-bootstrap-configtx-channel.sh
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID fabric-course
```

- 生成锚节点定义

```shell script
# fabric-bootstrap-configtx-anchors.sh
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
# ./scripts/cli-peer-channel.sh
# 创建通道
peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
# 移动channel block 文件提供其他节点加入复用
mv $CHANNEL_NAME.block ./channel-artifacts/
```

> 加入通道

```shell script
# ./scripts/cli-peer-channel.sh
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
```

> 更新锚节点

```shell script
# ./scripts/cli-peer-channel.sh
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
> 安装链码

```shell script
# ./scripts/cli-peer-chaincode.sh
## Chaincode install peer0.org1.example.com:7051
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
peer chaincode install -n mycc -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/chaincode_example02/node/
peer chaincode list --installed
## Chaincode install peer1.org1.example.com:8051
export CORE_PEER_ADDRESS=peer1.org1.example.com:8051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
peer chaincode install -n mycc -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/chaincode_example02/node/
peer chaincode list --installed
## Chaincode install peer0.org2.example.com:9051
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
peer chaincode install -n mycc -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/chaincode_example02/node/
peer chaincode list --installed
## Chaincode install peer1.org2.example.com:10051
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
peer chaincode install -n mycc -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/chaincode_example02/node/
peer chaincode list --installed
```

> 实例化链码

- 背书策略

```shell script
# 两个背书
-P "AND ('Org1MSP.peer','Org2MSP.peer')"
# 一个背书
-P "OR ('Org1MSP.peer','Org2MSP.peer')"
```

- 说明

```text
- Node.js 链码实例化大约需要一分钟。命令任务没有挂掉，而是在编译和安装 fabric-shim 层镜像。
- Java 链码初始化可能也会花费一些时间，它需要编译链码和下载 Java 环境 docker 镜像。
```

```shell script
# ./scripts/cli-peer-chaincode.sh
## Chaincode instantiate orderer.example.com:7050
export CHANNEL_NAME=fabric-course
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
peer chaincode instantiate -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n mycc -l node -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}' -P "AND ('Org1MSP.peer','Org2MSP.peer')"
peer chaincode list --instantiated -C $CHANNEL_NAME
```

#### 链码调用

```shell script
# ./scripts/peer-chaincode.sh
## Chaincode invoking peer0.org1.example.com:7051
export CHANNEL_NAME=fabric-course
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","b"]}'
peer chaincode invoke -o orderer.example.com:7050 --tls true \
      --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
      -C $CHANNEL_NAME \
      -n mycc \
      --peerAddresses peer0.org1.example.com:7051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
      --peerAddresses peer0.org2.example.com:9051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
      -c '{"Args":["invoke","a","b","10"]}' \
      --waitForEvent
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","b"]}'

## Chaincode invoking peer0.org2.example.com:9051
export CHANNEL_NAME=fabric-course
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","b"]}'
```

#### 网络关闭

```shell script
# fabric-docker-down.sh
# 停止
docker-compose -f docker-compose.yaml down
# 清理
# fabric-docker-clean.sh
```

#### 网络监视

```shell script
# fabric-docker-monitor.sh
```
