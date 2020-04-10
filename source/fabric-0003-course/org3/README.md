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
