#!/bin/bash
echo "
█████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████ █████

███████  █████  ██████  ██████  ██  ██████     ██    ██        ██    ██   ██     ██████
██      ██   ██ ██   ██ ██   ██ ██ ██          ██    ██       ███    ██   ██    ██
█████   ███████ ██████  ██████  ██ ██          ██    ██ █████  ██    ███████    ███████
██      ██   ██ ██   ██ ██   ██ ██ ██           ██  ██         ██         ██    ██    ██
██      ██   ██ ██████  ██   ██ ██  ██████       ████          ██ ██      ██ ██  ██████

█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗
╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝

███████ ████████  █████  ██████  ████████
██         ██    ██   ██ ██   ██    ██
███████    ██    ███████ ██████     ██
     ██    ██    ██   ██ ██   ██    ██
███████    ██    ██   ██ ██   ██    ██

█████ █████ █████ █████ █████ █████ █████
";


# ====================== shutdown : 停止

#./fabric-shutdown.sh

# ====================== cleanup : 清理

#./fabric-clean.sh

# ====================== bootstrap : 生成网络构件

# Generate certificates : 生成网络认证密钥
./01.bootstrap-crypto-generate.sh

# Generating Orderer Genesis block [Solo] : 生成通道所需创世区块[排序服务:Solo]
./02.bootstrap-configtx-genesis-solo.sh

# Generating channel configuration transaction 'channel.tx' : 生成通道所需交易配置
./03.bootstrap-configtx-channel.sh

# Generating anchor peer update : 生成锚节点更新所需配置
./04.bootstrap-configtx-anchors.sh

# ====================== startup : 启动

# Docker compose up
./05.bootstrap-docker-up.sh