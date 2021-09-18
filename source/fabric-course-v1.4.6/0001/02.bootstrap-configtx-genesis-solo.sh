#!/bin/bash
echo "##########################################################"
echo "#####  Generating Orderer Genesis block [Solo] ###########"
echo "##########################################################"
SYS_CHANNEL="byfn-sys-channel"
echo "Script variable : SYS_CHANNEL = " ${SYS_CHANNEL}

configtxgen -profile TwoOrgsOrdererGenesis -channelID ${SYS_CHANNEL} -outputBlock ./channel-artifacts/genesis.block
