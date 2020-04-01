#!/bin/bash
echo "##########################################################"
echo "#####  Generating Orderer Genesis block [Solo] ###########"
echo "##########################################################"
configtxgen -profile TwoOrgsOrdererGenesis -channelID course-sys-channel -outputBlock ./channel-artifacts/genesis.block
