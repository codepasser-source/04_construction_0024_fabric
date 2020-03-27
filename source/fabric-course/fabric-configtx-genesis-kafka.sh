#!/bin/bash
echo "##########################################################"
echo "#####  Generating Orderer Genesis block [Kafka] ##########"
echo "##########################################################"
configtxgen -profile SampleDevModeKafka -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
