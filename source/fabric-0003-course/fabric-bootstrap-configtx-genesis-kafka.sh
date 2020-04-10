#!/bin/bash
echo "##########################################################"
echo "#####  Generating Orderer Genesis block [Kafka] ##########"
echo "##########################################################"
export FABRIC_CFG_PATH=$PWD && configtxgen -profile SampleDevModeKafka -channelID course-sys-channel -outputBlock ./channel-artifacts/genesis.block
