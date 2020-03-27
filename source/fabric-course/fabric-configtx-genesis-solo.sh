#!/bin/bash
echo "##########################################################"
echo "#####  Generating Orderer Genesis block [Solo] ###########"
echo "##########################################################"
configtxgen -profile TwoOrgsOrdererGenesis -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
