## Fabric - 开发示例 0003 动态添加组织

### 过程纪要

#### 启动原始网络

#### 生成Org3构件

- crypto

```shell script
# fabric-bootstrap-crypto-generate.sh
cryptogen generate --config=./crypto-config.yaml
cp -r ../crypto-config/ordererOrganizations ./crypto-config/
```

- configtx

```shell script
# fabric-bootstrap-configtx-channel.sh
export FABRIC_CFG_PATH=$PWD && configtxgen -printOrg Org3MSP > ../channel-artifacts/org3.json
```


#### 配置Org3

- 获取配置
```shell script
# ../fabric-docker-cli.sh
docker exec -it cli bash

# ../script/cli-peer-org3.sh
export CHANNEL_NAME=fabric-course
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer channel fetch config config_block.pb -o orderer.example.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
```

- 修改配置

```shell script
# ../script/cli-peer-org3.sh
# 剪裁
configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Org3MSP":.[1]}}}}}' config.json ./channel-artifacts/org3.json > modified_config.json
configtxlator proto_encode --input config.json --type common.Config --output config.pb
configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb
mv config_block.pb ./channel-artifacts/
mv config.json ./channel-artifacts/
mv modified_config.json ./channel-artifacts/
```

- 签名并提交配置更新

```shell script
# ../script/cli-peer-org3.sh
peer channel signconfigtx -f org3_update_in_envelope.pb
```
