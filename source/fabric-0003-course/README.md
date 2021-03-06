## Fabric - 开发示例 0003

### 前言

> 教程参考

- [`first-network`](https://hyperledger-fabric.readthedocs.io/zh_CN/release-1.4/build_network.html#)
 
#### 环境准备 

> 00.fabric-environment.md
> 01.fabric-server-build.md
> 02.fabric-install.md

#### 示例说明

|    链码    |    状态存储    |    排序服务    |    组织    |    节点    |    排序节点    |    CA    |    集群    |  应用程序  |
|  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |
|    go(fabcar)    |   couchdb(0~1).org(1~2).example.com     |   kafka.example.com    |   Org(1~2)   |   peer(0~1).org(1~2).example.com     |   orderer.example.com     |   ca.org(1~2).example     |    单机环境    |  fabcar  |

* `couchdb`

    * `[couchdb utils](http://172.16.20.163:5984/_utils)`
    * `[couchdb utils](http://172.16.20.163:6984/_utils)`
    * `[couchdb utils](http://172.16.20.163:7984/_utils)`
    * `[couchdb utils](http://172.16.20.163:8984/_utils)`

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

- 生成 Kafka 排序服务的创世区块

```shell script
# fabric-bootstrap-configtx-genesis-kafka.sh
configtxgen -profile SampleDevModeKafka -channelID course-sys-channel -outputBlock ./channel-artifacts/genesis.block
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

> 客户端访问配置文件CPP

```shell script
# fabric-bootstrap-ccp-generate.sh
echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > ./application/connection-org1.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > ./application/connection-org1.yaml
echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > ./application/connection-org2.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > ./application/connection-org2.yaml
```

#### 启动网络

> 服务启动

```shell script
# fabric-docker-up.sh
# Exclude CA
docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml -f docker-compose-kafka.yaml up -d
# Include CA
export COURSE_CA1_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org1.example.com/ca && ls *_sk)
export COURSE_CA2_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org2.example.com/ca && ls *_sk)
echo "========== $COURSE_CA1_PRIVATE_KEY: "$COURSE_CA1_PRIVATE_KEY" =========="
echo "========== $COURSE_CA2_PRIVATE_KEY: "$COURSE_CA2_PRIVATE_KEY" =========="
docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml -f docker-compose-kafka.yaml -f docker-compose-ca.yaml up -d
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
peer chaincode install -n fabcar -v 1.0 -p github.com/chaincode/fabcar/go/
peer chaincode list --installed
## Chaincode install peer1.org1.example.com:8051
export CORE_PEER_ADDRESS=peer1.org1.example.com:8051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
peer chaincode install -n fabcar -v 1.0 -p github.com/chaincode/fabcar/go/
peer chaincode list --installed
## Chaincode install peer0.org2.example.com:9051
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
peer chaincode install -n fabcar -v 1.0 -p github.com/chaincode/fabcar/go/
peer chaincode list --installed
## Chaincode install peer1.org2.example.com:10051
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
peer chaincode install -n fabcar -v 1.0 -p github.com/chaincode/fabcar/go/
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
peer chaincode instantiate -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n fabcar -v 1.0 -c '{"Args":[]}' -P "AND ('Org1MSP.peer','Org2MSP.peer')"
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
      -n fabcar \
      --peerAddresses peer0.org1.example.com:7051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
      --peerAddresses peer0.org2.example.com:9051 \
      --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
      -c '{"function":"initLedger","Args":[]}' \
      --waitForEvent
peer chaincode query -C $CHANNEL_NAME -n fabcar -c '{"function":"queryAllCars","Args":[]}'
```

#### 应用程序

> 安装

```shell script
cd ./application/fabcar/javascript
npm install
```

> 注册admin

```shell script
node enrollAdmin.js
```

> 注册user1

```shell script
node registerUser.js
```

> 调用

```shell script
node invoke.js
node query.js
```

#### 网络关闭

```shell script
# fabric-docker-down.sh
# 停止
# Exclude CA
docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml -f docker-compose-kafka.yaml down
# Include CA
docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml -f docker-compose-kafka.yaml -f docker-compose-ca.yaml down
# 清理
# fabric-docker-clean.sh
```

#### 网络监视

```shell script
# fabric-docker-monitor.sh
```
