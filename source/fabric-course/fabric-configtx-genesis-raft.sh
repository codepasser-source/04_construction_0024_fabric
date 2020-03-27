#!/bin/bash
echo "##########################################################"
echo "#####  Generating Orderer Genesis block [Raft] ###########"
echo "##########################################################"
configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
