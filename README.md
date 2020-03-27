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

#### 密钥生成

> 配置文件

```shell script
crypto-config.yaml
```

> 生成密钥证书

```shell script
cryptogen generate --config=./crypto-config.yaml
```
