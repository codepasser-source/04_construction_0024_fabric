## Fabric - 开发示例 0004

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

* `etcdRaft`

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

```shell script
# fabric-bootstrap-crypto-generate.sh
cryptogen generate --config=./crypto-config.yaml
```

> 生成创世区块

- 生成 Raft 排序服务的创世区块

```shell script
# fabric-bootstrap-configtx-genesis-raft.sh
configtxgen -profile SampleMultiNodeEtcdRaft -channelID course-sys-channel -outputBlock ./channel-artifacts/genesis.block
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
# Exclude CA
docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml -f docker-compose-etcdraft.yaml up -d
# Include CA
export COURSE_CA1_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org1.example.com/ca && ls *_sk)
export COURSE_CA2_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org2.example.com/ca && ls *_sk)
echo "========== COURSE_CA1_PRIVATE_KEY: $COURSE_CA1_PRIVATE_KEY =========="
echo "========== COURSE_CA2_PRIVATE_KEY: $COURSE_CA2_PRIVATE_KEY =========="
docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml -f docker-compose-etcdraft.yaml -f docker-compose-ca.yaml up -d
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
peer chaincode install -n marbles -v 1.0 -p github.com/chaincode/marbles02/go/
peer chaincode list --installed
## Chaincode install peer1.org1.example.com:8051
export CORE_PEER_ADDRESS=peer1.org1.example.com:8051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
peer chaincode install -n marbles -v 1.0 -p github.com/chaincode/marbles02/go/
peer chaincode list --installed
## Chaincode install peer0.org2.example.com:9051
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
peer chaincode install -n marbles -v 1.0 -p github.com/chaincode/marbles02/go/
peer chaincode list --installed
## Chaincode install peer1.org2.example.com:10051
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
peer chaincode install -n marbles -v 1.0 -p github.com/chaincode/marbles02/go/
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
peer chaincode instantiate -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n marbles -v 1.0 -c '{"Args":["init"]}' -P "AND ('Org1MSP.peer','Org2MSP.peer')"
peer chaincode list --instantiated -C $CHANNEL_NAME
```

#### 链码调用

```shell script
# ./scripts/peer-chaincode.sh
## Chaincode invoking peer0.org1.example.com:7051
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
peer chaincode invoke -o orderer.example.com:7050 \
      --tls true \
      --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
      -C $CHANNEL_NAME \
      -n marbles \
      --peerAddresses peer0.org1.example.com:7051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
      --peerAddresses peer0.org2.example.com:9051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
      -c '{"Args":["initMarble","marble1","blue","35","tom"]}' \
      --waitForEvent
peer chaincode invoke -o orderer.example.com:7050 \
      --tls true \
      --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
      -C $CHANNEL_NAME \
      -n marbles \
      --peerAddresses peer0.org1.example.com:7051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
      --peerAddresses peer0.org2.example.com:9051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
      -c '{"Args":["initMarble","marble2","red","50","tom"]}' \
      --waitForEvent
peer chaincode invoke -o orderer.example.com:7050 \
      --tls true \
      --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
      -C $CHANNEL_NAME \
      -n marbles \
      --peerAddresses peer0.org1.example.com:7051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
      --peerAddresses peer0.org2.example.com:9051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
      -c '{"Args":["initMarble","marble3","blue","70","tom"]}' \
      --waitForEvent
peer chaincode invoke -o orderer.example.com:7050 \
      --tls true \
      --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
      -C $CHANNEL_NAME \
      -n marbles \
      --peerAddresses peer0.org1.example.com:7051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
      --peerAddresses peer0.org2.example.com:9051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
      -c '{"Args":["transferMarble","marble2","jerry"]}' \
      --waitForEvent
peer chaincode invoke -o orderer.example.com:7050 \
      --tls true \
      --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
      -C $CHANNEL_NAME \
      -n marbles \
      --peerAddresses peer0.org1.example.com:7051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
      --peerAddresses peer0.org2.example.com:9051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
      -c '{"Args":["transferMarblesBasedOnColor","blue","jerry"]}' \
      --waitForEvent
peer chaincode invoke -o orderer.example.com:7050 \
      --tls true \
      --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
      -C $CHANNEL_NAME \
      -n marbles \
      --peerAddresses peer0.org1.example.com:7051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
      --peerAddresses peer0.org2.example.com:9051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
      -c '{"Args":["delete","marble1"]}' \
      --waitForEvent
peer chaincode query -C $CHANNEL_NAME -n marbles -c '{"Args":["readMarble","marble2"]}'
peer chaincode query -C $CHANNEL_NAME -n marbles -c '{"Args":["getHistoryForMarble","marble1"]}'
peer chaincode query -C $CHANNEL_NAME -n marbles -c '{"Args":["queryMarblesByOwner","jerry"]}'
```

#### 网络关闭

```shell script
# fabric-docker-down.sh
# 停止
# Exclude CA
docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml -f docker-compose-etcdraft.yaml down
# Include CA
docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml -f docker-compose-etcdraft.yaml -f docker-compose-ca.yaml down
# 清理
# fabric-docker-clean.sh
```

#### 网络监视

```shell script
# fabric-docker-monitor.sh
```
